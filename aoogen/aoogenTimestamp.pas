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
    FDateTimeSeparator: string;
    FMsecSeparator: string;

    procedure Reset;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string; override;

    property DateSeparator: string read FDateSeparator;
    property TimeSeparator: string read FTimeSeparator;
    property DateTimeSeparator: string read FDateTimeSeparator;
    property MsecSeparator: string read FMsecSeparator;
    property IsoMode: Boolean read FIsoMode;
    property HumanMode: Boolean read FHumanMode;
    property SolidMode: Boolean read FSolidMode;
  end;

  TTimestampStringGenerator = class(TAoogenGenerator)
  private
    class function GenetateSolidTimestampString: string;
    class function GenetateIsoTimestampString: string;
    class function GenetateHumanTimestampString: string;
    class function GenetateTimestampString(const aArgs: TTimestampStringGeneratorArg): string;
  public
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
    if (not vArgs.SolidMode) then begin
      if (vArgs.IsoMode) then
        Result := GenetateIsoTimestampString
      else if (vArgs.HumanMode) then
        Result := GenetateHumanTimestampString
      else
        Result := GenetateTimestampString(vArgs);
    end;
  end;
end;


class function TTimestampStringGenerator.GenetateHumanTimestampString: string;
const
  cFmtLocalSettingsTimestamp = 'yyyy/mm/dd hh:nn:ss.zzz';
begin
  Result := FormatDateTime(cFmtLocalSettingsTimestamp, Now);
end;


class function TTimestampStringGenerator.GenetateTimestampString(const aArgs: TTimestampStringGeneratorArg): string;
const
  cFmtTimestamp = 'yyyy"%s"mm"%s"dd"%s"hh"%s"nn"%s"ss"%s"zzz';
var
  vFmtTimestamp: string;
begin
  if (Assigned(aArgs)) then begin
    vFmtTimestamp := Format(cFmtTimestamp, [
      aArgs.DateSeparator, aArgs.DateSeparator, aArgs.DateSeparator
    , aArgs.DateTimeSeparator
    , aArgs.TimeSeparator, aArgs.TimeSeparator, aArgs.TimeSeparator
    , aArgs.MsecSeparator
    ]);
    Result := FormatDateTime(vFmtTimestamp, Now);
  end else
    Result := GenetateSolidTimestampString;
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
  FSolidMode := True;
  inherited;
end;


destructor TTimestampStringGeneratorArg.Destroy;
begin

  inherited;
end;


procedure TTimestampStringGeneratorArg.Reset;
begin
  FSolidMode := False;
  FIsoMode := False;
  FHumanMode := False;
  FDateSeparator := EmptyStr;
  FTimeSeparator := EmptyStr;
  FMsecSeparator := EmptyStr;
end;


function TTimestampStringGeneratorArg.SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string;
type
  TTimestampKeyArgItem = (taiNone, taiHuman {aka "local settings"}, taiIso, taiMinus, taiDot, taiSolid);

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
  cTimestampDividerDot = '.';
  cTimestampKeyArgCount = 1;
  cTimestampKeyArgArray: array[TTimestampKeyArgItem] of TTimestampKeyArgDocket = (
    (Item: taiNone;  ShortName: '-'; LongName: '--';)
  , (Item: taiHuman; ShortName: 'h'; LongName: 'human';)
//, (Item: taiHuman; ShortName: 'l'; LongName: 'local';)
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
  Reset;
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
          FDateTimeSeparator := cTimestampDividerMinus;
        end;
        taiDot: begin
          FDateSeparator := cTimestampDividerDot;
          FTimeSeparator := cTimestampDividerDot;
          FMsecSeparator := cTimestampDividerDot;
          FDateTimeSeparator := cTimestampDividerDot;
        end;
        taiSolid: FSolidMode := True;
      end;

      vI := vI + 1;
    end;

  end;

end;

end.
