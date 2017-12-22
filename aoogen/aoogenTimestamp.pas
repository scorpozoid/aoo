unit aoogenTimestamp;

interface
uses
  // {$IFDEF MSWINDOWS}
  // Windows,
  // {$ENDIF} // MSWINDOWS
  SysUtils, DateUtils, Classes, TimeSpan,
  aoogenGenerator;

type
  TTimestampStringGeneratorArg = class(TAoogenGeneratorArgs)
  private
    FIsoMode: Boolean;
    FHumanMode: Boolean;
    FSolidMode: Boolean;
    FDateSeparator: string;
    FTimeSeparator: string;
    FMsecSeparator: string;

    procedure Reset;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string; override;

    property DateSeparator: string read FDateSeparator;
    property TimeSeparator: string read FTimeSeparator;
    property MsecSeparator: string read FMsecSeparator;
    property IsoMode: Boolean read FIsoMode;
    property HumanMode: Boolean read FHumanMode;
    property SolidMode: Boolean read FSolidMode;
  end;

  TTimestampStringGenerator = class(TAoogenGenerator)
  public
    class function GenetateSolidTimestampString: string;
    class function GenetateIsoTimestampString: string;
    function GenerateValue(const aArgs: TAoogenGeneratorArgs): string; override;
  end;

implementation


{ TTimestampStringGenerator }

function TTimestampStringGenerator.GenerateValue(const aArgs: TAoogenGeneratorArgs): string;
var
  vArgs: TTimestampStringGeneratorArg;
begin
  Result := GenetateSolidTimestampString;
  if (aArgs is TTimestampStringGeneratorArg) then begin
    vArgs := aArgs as TTimestampStringGeneratorArg;
    if (vArgs.IsoMode) then begin
      Result := GenetateIsoTimestampString;
    end;
  end;
end;


class function TTimestampStringGenerator.GenetateIsoTimestampString: string;
var
  vTimeZone: TTimeZone;
  vOffset: Integer;
  vNow: TDateTime;
  vUtcOffset: string;
  vUtcOffsetSing: string;
const
  cFmtSolidTimestamp = 'yyyy"-"mm"-"dd"T"hh":"nn":"ss"."zzz';
begin
  vNow := Now;
  Result := FormatDateTime(cFmtSolidTimestamp, vNow);
  vTimeZone := TTimeZone.Local;
  vOffset := vTimeZone.GetUtcOffset(vNow).Hours;
  vUtcOffsetSing := '+';
  if (0 > vOffset) then
    vUtcOffsetSing := '-';
  vUtcOffset := IntToStr(Abs(vOffset));
  if (2 > Length(vUtcOffset)) then
    vUtcOffset := '0' + vUtcOffset;
  Result := Result + vUtcOffsetSing + vUtcOffset;

  // {$IFDEF MSWINDOWS}
  // OutputDebugString(PWideChar(vUtcOffset));
  // {$ENDIF} // MSWINDOWS
end;


class function TTimestampStringGenerator.GenetateSolidTimestampString: string;
const
  cFmtSolidTimestamp = 'yyyymmddhhnnsszzz';
begin
  Result := FormatDateTime(cFmtSolidTimestamp, Now);
end;


{ TTimestampStringGeneratorArg }

constructor TTimestampStringGeneratorArg.Create(AOwner: TComponent);
begin
  Reset;
  inherited;

end;


destructor TTimestampStringGeneratorArg.Destroy;
begin

  inherited;
end;


procedure TTimestampStringGeneratorArg.Reset;
begin
  FSolidMode := True;
  FIsoMode := False;
  FHumanMode := False;
  FDateSeparator := EmptyStr;
  FTimeSeparator := EmptyStr;
  FMsecSeparator := EmptyStr;
end;


function TTimestampStringGeneratorArg.SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string;
type
  TTimestampKeyArgItem = (taiNone, taiHuman, taiIso, taiMinus, taiDot, taiSolid);

  TTimestampKeyArgDocket = record
    Item: TTimestampKeyArgItem;
    ShortName: string;
    LongName: string;
  end;

var
  vI: Integer;
  vParameter: string;
  vItem: TTimestampKeyArgItem;

const
  cTimestampDividerMinus = '-';
  cTimestampDividerDot = '-';
  cTimestampKeyArgCount = 1;
  cTimestampKeyArgArray: array[TTimestampKeyArgItem] of TTimestampKeyArgDocket = (
    (Item: taiNone;  ShortName: '-'; LongName: '--';)
  , (Item: taiHuman; ShortName: 'h'; LongName: 'human';)
  , (Item: taiIso;   ShortName: 'i'; LongName: 'iso';)
  , (Item: taiMinus; ShortName: 'm'; LongName: 'minus';)
  , (Item: taiDot;   ShortName: 'd'; LongName: 'dot';)
  , (Item: taiSolid; ShortName: 's'; LongName: 'solid';)
  );

  function UniCase(const aString: string): string;
  begin
    Result := LowerCase(aString);
  end;

  function GetTimestampKeyArgItem(const aStringValue: string): TTimestampKeyArgItem;
  var
    vJ: TTimestampKeyArgItem;
    vSuitable: Boolean;
    vValue: string;
  begin
    Result := taiNone;
    vValue := UniCase(Trim(aStringValue));
    for vJ := Low(TTimestampKeyArgItem) to High(TTimestampKeyArgItem) do begin
      vSuitable :=
           SameText(vValue, '-' + cTimestampKeyArgArray[vJ].ShortName)
        or SameText(vValue, '/' + cTimestampKeyArgArray[vJ].ShortName)
        or SameText(vValue, '--' + cTimestampKeyArgArray[vJ].LongName);
      if (vSuitable) then begin
        Result := vJ;
        Break;
      end;
    end;
  end;

begin
  if (0 < Length(aParameterArray)) then begin
    vI := Low(aParameterArray);
    while (vI <= High(aParameterArray)) do begin
      vParameter := aParameterArray[vI];
      vItem := GetTimestampKeyArgItem(vParameter);
      case (vItem) of
        taiHuman: FHumanMode := True;
        taiIso: FIsoMode := True;
        taiMinus: begin
          FDateSeparator := cTimestampDividerMinus;
          FTimeSeparator := cTimestampDividerMinus;
          FMsecSeparator := cTimestampDividerMinus;
        end;
        taiDot: begin
          FDateSeparator := cTimestampDividerDot;
          FTimeSeparator := cTimestampDividerDot;
          FMsecSeparator := cTimestampDividerDot;
        end;
        taiSolid: FSolidMode := True;
      else
        Reset;
      end;

      vI := vI + 1;
    end;

  end;

end;

end.
