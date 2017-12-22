unit aoogenRandom;

interface
uses
  SysUtils, Math, Classes,
  aoogenGenerator;

type
  TRandomStringGeneratorArg = class(TAoogenGeneratorArgs)
  strict private
    FPadding: Boolean;
    FPadChar: Char;
    FOffset: Int64;
    FRange: Int64;
  private
    procedure Reset;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string; override;

    property Range: Int64 read FRange;
    property Offset: Int64 read FOffset;
    property Padding: Boolean read FPadding;
    property PadChar: Char read FPadChar;
  end;

  TRandomStringGenerator = class(TAoogenGenerator)
  private
    function GenerateRandomValue(const aOffset: Int64; const aRange: Int64): Int64;
  public
    function GenerateValue(const aArgs: TAoogenGeneratorArgs): string; override;
  end;


implementation
const
  cDefaultRange = 100;
  cDefaultOffset = 0;


{ TRandomStringGeneratorArg }

constructor TRandomStringGeneratorArg.Create(AOwner: TComponent);
begin
  Reset;
  inherited;
end;


destructor TRandomStringGeneratorArg.Destroy;
begin

  inherited;
end;


procedure TRandomStringGeneratorArg.Reset;
begin
  FPadding := False;
  FPadChar := ' ';
  FOffset := cDefaultOffset;
  FRange := cDefaultRange;
end;


function TRandomStringGeneratorArg.SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string;
type
  TRandomParamItem = (rpiNone, rpiRange, rpiOffset, rpiZeroPadding, rpiSpacePadding);

  TRandomParamDocket = record
    Item: TRandomParamItem;
    ShortName: string;
    LongName: string;
  end;

var
  vI, vV: Integer;
  vX: Integer;
  vParameter: string;
  vValue: string;
  vItem: TRandomParamItem;

  function UniCase(const aString: string): string;
  begin
    Result := LowerCase(aString);
  end;

  function GetGuidKeyArgItem(const aStringValue: string): TRandomParamItem;
  var
    vK: TRandomParamItem;
    vY: Integer;
    vSuitable: Boolean;
    vValue: string;
    vValues: TStringList;
    vKeys: TStringList;
  const
    cRandomParamArray: array[TRandomParamItem] of TRandomParamDocket = (
      (Item: rpiNone;         ShortName: '-'; LongName: '--';)
    , (Item: rpiRange;        ShortName: 'r'; LongName: 'range';)
    , (Item: rpiOffset;       ShortName: 'o'; LongName: 'offset';)
    , (Item: rpiZeroPadding;  ShortName: 'z|zp'; LongName: 'zeropad|zeropadding|zero-pad|zero-padding';)
    , (Item: rpiSpacePadding; ShortName: 's|Sp'; LongName: 'spacepad|spacepadding|space-pad|space-padding';)
    );
  begin
    Result := rpiNone;
    vValue := UniCase(Trim(aStringValue));
    for vK := Low(TRandomParamItem) to High(TRandomParamItem) do begin
      vValues := TStringList.Create;
      try
        vValues.Sorted := True;
        vValues.Duplicates := dupIgnore;
        vKeys := TStringList.Create;
        try
          vKeys.Delimiter := '|';

          vKeys.Clear;
          vKeys.DelimitedText := cRandomParamArray[vK].ShortName;
          for vY := 0 to vKeys.Count - 1 do begin
            vValues.Add('-' + UniCase(vKeys[vY]));
            vValues.Add('/' + UniCase(vKeys[vY]));
          end;

          vKeys.Clear;
          vKeys.DelimitedText := cRandomParamArray[vK].LongName;
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

  function IsValidRangeValue(const aRangeValue: string): Boolean;
  var
    vInvalid: Boolean;
    vDummie: Int64;
  begin
    Result := False;
    vInvalid :=
         aRangeValue.StartsWith('-')
      or aRangeValue.StartsWith('/');
    if (not vInvalid) then
      Result := TryStrToInt64(aRangeValue, vDummie);
  end;

  procedure SetRangeValue(const aRangeValue: string);
  begin
    FRange := StrToInt64Def(aRangeValue, cDefaultRange);
  end;

  function IsValidOffsetValue(const aOffsetValue: string): Boolean;
  var
    vInvalid: Boolean;
    vDummie: Int64;
  begin
    Result := False;
    vInvalid :=
         aOffsetValue.StartsWith('-')
      or aOffsetValue.StartsWith('/');
    if (not vInvalid) then
      Result := TryStrToInt64(aOffsetValue, vDummie);
  end;

  procedure SetOffsetValue(const aOffsetValue: string);
  begin
    FOffset := StrToInt64Def(aOffsetValue, cDefaultOffset);
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

          rpiRange: begin
            if (EmptyStr = vValue) then begin
              vV := vI + 1;
              if (vV <= High(aParameterArray)) then begin
                vValue := aParameterArray[vV];
                if (IsValidRangeValue(vValue)) then begin
                  SetRangeValue(vValue);
                  vI := vI + 2;
                  Continue;
                end;
              end;
            end else begin
              SetRangeValue(vValue);
            end;
          end;

          rpiOffset: begin
            if (EmptyStr = vValue) then begin
              vV := vI + 1;
              if (vV <= High(aParameterArray)) then begin
                vValue := aParameterArray[vV];
                if (IsValidOffsetValue(vValue)) then begin
                  SetOffsetValue(vValue);
                  vI := vI + 2;
                  Continue;
                end;
              end;
            end else begin
              SetOffsetValue(vValue);
            end;
          end;

          rpiZeroPadding: begin
            FPadding := True;
            FPadChar := '0';
          end;

          rpiSpacePadding: begin
            FPadding := True;
            FPadChar := ' ';
          end;

        end;
      end;
      vI := vI + 1;
    end;
  end;
end;


{ TRandomStringGenerator }

function TRandomStringGenerator.GenerateRandomValue(const aOffset: Int64; const aRange: Int64): Int64;
var
  vRandom: Extended;
begin
  vRandom := Random;
  Result := Trunc(aOffset + vRandom * aRange);
end;


function TRandomStringGenerator.GenerateValue(const aArgs: TAoogenGeneratorArgs): string;
var
  vArgs: TRandomStringGeneratorArg;
  vRandom: Int64;
begin
  if (aArgs is TRandomStringGeneratorArg) then begin
    vArgs := aArgs as TRandomStringGeneratorArg;
    vRandom := GenerateRandomValue(vArgs.Offset, vArgs.Range);
  end else begin
    vRandom := GenerateRandomValue(cDefaultOffset, cDefaultRange);
  end;
  Result := IntToStr(vRandom);
end;

initialization
  Randomize;

end.
