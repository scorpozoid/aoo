unit aoogenGuid;

interface
uses
  SysUtils, StrUtils, Classes,
  aoogenGenerator;

type
  TGuidStringChartCase = (gsccUnknown, gsccUpper, gsccLower);
  TGuidStringWrapModeItem = (gswmNone, gswmAngleBraces, gswmCurlyBraces, gswmSquareBraces, gswmSingleQuotes, gswmDoubleQuotes);
  TGuidStringWrapMode = array of TGuidStringWrapModeItem;

  TGuidStringGeneratorArgs = class(TAoogenGeneratorArgs)
  strict private
    FWrapMode: TGuidStringWrapMode;
    FSolid: Boolean;
    FDivider: string;
    FCharCase: TGuidStringChartCase;

    procedure Reset;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string; override;

    property Solid: Boolean read FSolid;
    property WrapMode: TGuidStringWrapMode read FWrapMode;
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
  vW: Integer;
begin
  if (aArgs is TGuidStringGeneratorArgs) then begin
    vArgs := aArgs as TGuidStringGeneratorArgs;
    CreateGUID(vGuid);
    Result := GUIDToString(vGuid);
    Result := ReplaceStr(Result, '{', '');
    Result := ReplaceStr(Result, '}', '');

    Result := ReplaceStr(Result, '-', vArgs.Divider);
    case (vArgs.CharCase) of
      gsccUpper: Result := UpperCase(Result);
      gsccLower: Result := LowerCase(Result);
    end;

    if (0 < Length(vArgs.WrapMode)) then begin
      for vW := Low(vArgs.WrapMode) to High(vArgs.WrapMode) do begin
        case (vArgs.WrapMode[vW]) of
          gswmAngleBraces:  Result := '<' + Result + '>';
          gswmCurlyBraces:  Result := '{' + Result + '}';
          gswmSquareBraces: Result := '[' + Result + ']';
          gswmSingleQuotes: Result := '''' + Result + '''';
          gswmDoubleQuotes: Result := '"' + Result + '"';
        end;
      end;
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
  FWrapMode := nil;
  FSolid := False;
  FDivider := EmptyStr;
  FCharCase := gsccUnknown;
end;


function TGuidStringGeneratorArgs.SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string;
type
  TGuidKeyArgItem = (gkaiNone, gkaiMinus, gkaiDot, gkaiColon, gkaiSolid, gkaiWrap, gkaiUpperCase, gkaiLowerCase);

  TGuidKeyArgDocket = record
    Item: TGuidKeyArgItem;
    ShortName: string;
    LongName: string;
  end;

var
  vI, vV: Integer;
  vX: Integer;
  vParameter: string;
  vValue: string;
  vItem: TGuidKeyArgItem;

const
  cGuidKeyArgArray: array[TGuidKeyArgItem] of TGuidKeyArgDocket = (
    (Item: gkaiNone;        ShortName:    '-'; LongName: '--';)
  , (Item: gkaiMinus;       ShortName:    'm'; LongName: 'minus';)
  , (Item: gkaiDot;         ShortName:    'd'; LongName: 'dot';)
  , (Item: gkaiColon;       ShortName:    'c'; LongName: 'colon';)
  , (Item: gkaiSolid;       ShortName:    's'; LongName: 'solid';)
  , (Item: gkaiWrap;        ShortName:    'w'; LongName: 'wrap';)
  , (Item: gkaiUpperCase;   ShortName: 'u|uc'; LongName: 'upper|uppercase';)
  , (Item: gkaiLowerCase;   ShortName: 'l|lc'; LongName: 'lower|lowercase';)
  );

  function UniCase(const aString: string): string;
  begin
    Result := LowerCase(aString);
  end;

  function GetGuidKeyArgItem(const aStringValue: string): TGuidKeyArgItem;
  var
    vK: TGuidKeyArgItem;
    vY: Integer;
    vSuitable: Boolean;
    vValue: string;
    vValues: TStringList;
    vKeys: TStringList;
  begin
    Result := gkaiNone;
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
          for vY := 0 to vKeys.Count - 1 do begin
            vValues.Add('-' + UniCase(vKeys[vY]));
            vValues.Add('/' + UniCase(vKeys[vY]));
          end;

          vKeys.Clear;
          vKeys.DelimitedText := cGuidKeyArgArray[vK].LongName;
          for vY := 0 to vKeys.Count - 1 do begin
            vValues.Add('--' + UniCase(vKeys[vY]));
          end;

        finally
          vKeys.Free;
        end;

        vSuitable := vValues.Find(vValue, vY);
        if (vSuitable) then begin
          Result := vK;
          Break;
        end;

      finally
        vValues.Free;
      end;
    end;
  end;

  function GetWrapModeItem(const aWrapModeItemString: string): TGuidStringWrapModeItem;
  var
    vString: string;
    vM: TGuidStringWrapModeItem;
    vModeNames: TStringList;
    vDummie: Integer;
  const
    cWrapModeNames: array[TGuidStringWrapModeItem] of string = (
      {gswmNone}         '',
      {gswmAngleBraces}   'ab|angle|anglebrace|anglebraces',
      {gswmCurlyBraces}   'cb|curly|curlybrace|curlybraces',
      {gswmSquareBraces}  'sb|square|squarebrace|squarebraces',
      {gswmSingleQuotes}  'sq|single|singlequote|singlequotes',
      {gswmDoubleQuotes}  'dq|double|doublequote|doublequotes'
    );
  begin
    Result := gswmNone;
    vString := UniCase(Trim(aWrapModeItemString));
    if (EmptyStr <> vString) then begin
      vModeNames := TStringList.Create;
      try
        vModeNames.Sorted := True;
        vModeNames.Duplicates := dupIgnore;
        vModeNames.Delimiter := '|';
        for vM := Low(cWrapModeNames) to High(cWrapModeNames) do begin
          vModeNames.Clear;
          if (EmptyStr <> cWrapModeNames[vM]) then begin
            vModeNames.DelimitedText := cWrapModeNames[vM];
            if (vModeNames.Find(vString, vDummie)) then begin
              Result := vM;
              Break;
            end;
          end;
        end
      finally
        vModeNames.Free;
      end;
    end;
  end;

  procedure SetWrapValue(const aWrapValue: string);
  var
    vItems: TStringList;
    vWrapValue: string;
    vWrapValueItem: string;
    vW: Integer;
    vItem: TGuidStringWrapModeItem;
  begin
    FWrapMode := nil;
    vWrapValue := UniCase(Trim(ReplaceStr(aWrapValue, ' ', '')));
    if (EmptyStr <> vWrapValue) then begin
      vItems := TStringList.Create;
      try
        vItems.CommaText := vWrapValue;
        for vW := 0 to vItems.Count - 1 do begin
          vWrapValueItem := vItems[vW];
          vItem := GetWrapModeItem(vWrapValueItem);
          if (gswmNone <> vItem) then begin
            SetLength(FWrapMode, Length(FWrapMode) + 1);
            FWrapMode[Length(FWrapMode) - 1] := vItem;
          end;
        end;
      finally
        vItems.Free;
      end;
    end;
  end;

  function IsValidWrapValue(const aWrapValue: string): Boolean;
  var
    vInvalid: Boolean;
  begin
    vInvalid :=
         aWrapValue.StartsWith('-')
      or aWrapValue.StartsWith('/');
    Result := not vInvalid;
  end;

begin
  Reset;
  if (0 < Length(aParameterArray)) then begin
    vI := Low(aParameterArray);
    while (vI <= High(aParameterArray)) do begin
      vParameter := aParameterArray[vI];
      vValue := EmptyStr;
      if (0 < Length(vParameter)) then begin
        vX := Pos('=', vParameter);
        if (Low(vParameter) < vX) then begin
          vValue := Copy(vParameter, vX + 1, Length(vParameter) - vX);
          vParameter := Copy(vParameter, Low(vParameter), vX - 1);
        end;

        vItem := GetGuidKeyArgItem(vParameter);
        case (vItem) of
          gkaiMinus: FDivider := '-';
          gkaiDot: FDivider := '.';
          gkaiColon: FDivider := ':';
          gkaiSolid: FDivider := '';
          gkaiWrap: begin
            if (EmptyStr = vValue) then begin
              vV := vI + 1;
              if (vV <= High(aParameterArray)) then begin
                vValue := aParameterArray[vV];
                if (IsValidWrapValue(vValue)) then begin
                  SetWrapValue(vValue);
                  vI := vI + 2;
                  Continue;
                end;
              end;
            end else begin
              SetWrapValue(vValue);
            end;
          end;
          gkaiUpperCase: FCharCase := gsccUpper;
          gkaiLowerCase: FCharCase := gsccLower;
        end;
      end;
      vI := vI + 1;
    end;
  end;
end;

end.
