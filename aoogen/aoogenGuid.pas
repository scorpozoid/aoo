unit aoogenGuid;

interface
uses
  SysUtils, StrUtils, Classes,
  aoogenGenerator;

type
  TGuidStringChartCase = (gsccUnknown, gsccUpper, gsccLower);
  TGuidStringQ

  TGuidStringGeneratorArgs = class(TAoogenGeneratorArgs)
  strict private
    FCurlyBraces: Boolean;
    FSolid: Boolean;
    FDivider: string;
    FCharCase: TGuidStringChartCase;

    procedure Reset;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string; override;

    property Solid: Boolean read FSolid;
    property CurlyBraces: Boolean read FCurlyBraces;
    property Divider: string read FDivider;
    property CharCase: TGuidStringChartCase read FCharCase;
  end;

  TGuidStringGenerator = class(TAoogenGenerator)
  public
    class function GenetateDefaultGuidString: string;
    function GenerateValue(const aArgs: TAoogenGeneratorArgs): string; override;
  end;

implementation

{ TGuidStringGenerator }

function TGuidStringGenerator.GenerateValue(const aArgs: TAoogenGeneratorArgs): string;
var
  vArgs: TGuidStringGeneratorArgs;
  vGuid: TGUID;
begin
  if (aArgs is TGuidStringGeneratorArgs) then begin
    vArgs := aArgs as TGuidStringGeneratorArgs;
    CreateGUID(vGuid);
    Result := GUIDToString(vGuid);
    if (not vArgs.CurlyBraces) then begin
      Result := ReplaceStr(Result, '{', '');
      Result := ReplaceStr(Result, '}', '');
    end;

    Result := ReplaceStr(Result, '-', vArgs.Divider);
    case (vArgs.CharCase) of
      gsccUpper: Result := UpperCase(Result);
      gsccLower: Result := LowerCase(Result);
    end;

  end else begin
    Result := GenetateDefaultGuidString;
  end;
end;


class function TGuidStringGenerator.GenetateDefaultGuidString: string;
var
  vGuid: TGUID;
begin
  CreateGUID(vGuid);
  Result := GUIDToString(vGuid);
  Result := ReplaceStr(Result, '{', '');
  Result := ReplaceStr(Result, '}', '');
  Result := ReplaceStr(Result, '-', '');
end;


{ TGuidStringGeneratorArgs }

constructor TGuidStringGeneratorArgs.Create(AOwner: TComponent);
begin
  Reset;
  FSolid := True;
  inherited;
end;


destructor TGuidStringGeneratorArgs.Destroy;
begin
  inherited;
end;


procedure TGuidStringGeneratorArgs.Reset;
begin
  FCurlyBraces := False;
  FSolid := False;
  FDivider := EmptyStr;
  FCharCase := gsccUnknown;
end;


function TGuidStringGeneratorArgs.SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string;
type
  TGuidKeyArgItem = (taiNone, taiMinus, taiDot, taiColon, taiSolid, taiCurlyBraces, taiUpperCase, taiLowerCase);

  TGuidKeyArgDocket = record
    Item: TGuidKeyArgItem;
    ShortName: string;
    LongName: string;
  end;

var
  vI: Integer;
  vParameter: string;
  vItem: TGuidKeyArgItem;

const
  cGuidKeyArgArray: array[TGuidKeyArgItem] of TGuidKeyArgDocket = (
    (Item: taiNone;        ShortName:    '-'; LongName: '--';)
  , (Item: taiMinus;       ShortName:    'm'; LongName: 'minus';)
  , (Item: taiDot;         ShortName:    'd'; LongName: 'dot';)
  , (Item: taiColon;       ShortName:    'c'; LongName: 'colon';)
  , (Item: taiSolid;       ShortName:    's'; LongName: 'solid';)
  , (Item: taiCurlyBraces; ShortName: 'b|cb'; LongName: 'brace|braces|curlybrace|curlybraces';)
  , (Item: taiUpperCase;   ShortName: 'u|uc'; LongName: 'upper|uppercase';)
  , (Item: taiLowerCase;   ShortName: 'l|lc'; LongName: 'lower|lowercase';)
  );

  function UniCase(const aString: string): string;
  begin
    Result := LowerCase(aString);
  end;

  function GetGuidKeyArgItem(const aStringValue: string): TGuidKeyArgItem;
  var
    vK: TGuidKeyArgItem;
    vV: Integer;
    vSuitable: Boolean;
    vValue: string;
    vValues: TStringList;
    vKeys: TStringList;
  begin
    Result := taiNone;
    vValue := UniCase(Trim(aStringValue));
    for vK := Low(TGuidKeyArgItem) to High(TGuidKeyArgItem) do begin
      vValues := TStringList.Create;
      try
        vValues.Sorted := True;
        vValues.Duplicates := dupIgnore;
        vKeys := TStringList.Create;
        try
          vKeys.Delimiter := '|';

          vKeys.Clear;
          vKeys.DelimitedText := cGuidKeyArgArray[vK].ShortName;
          for vV := 0 to vKeys.Count - 1 do begin
            vValues.Add('-' + UniCase(vKeys[vV]));
            vValues.Add('/' + UniCase(vKeys[vV]));
          end;

          vKeys.Clear;
          vKeys.DelimitedText := cGuidKeyArgArray[vK].LongName;
          for vV := 0 to vKeys.Count - 1 do begin
            vValues.Add('--' + UniCase(vKeys[vV]));
          end;

        finally
          vKeys.Free;
        end;

        vSuitable := vValues.Find(vValue, vV);
        if (vSuitable) then begin
          Result := vK;
          Break;
        end;

      finally
        vValues.Free;
      end;
    end;
  end;


begin
  Reset;
  if (0 < Length(aParameterArray)) then begin
    vI := Low(aParameterArray);
    while (vI <= High(aParameterArray)) do begin
      vParameter := aParameterArray[vI];
      vItem := GetGuidKeyArgItem(vParameter);
      case (vItem) of
        taiMinus: FDivider := '-';
        taiDot: FDivider := '.';
        taiColon: FDivider := ':';
        taiSolid: FDivider := '';
        taiCurlyBraces: FCurlyBraces := True;
        taiUpperCase: FCharCase := gsccUpper;
        taiLowerCase: FCharCase := gsccLower;
      end;
      vI := vI + 1;
    end;
  end;
end;

end.
