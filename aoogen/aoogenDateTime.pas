unit aoogenDateTime;

interface
uses
  // {$IFDEF MSWINDOWS}
  // Windows,
  // {$ENDIF} // MSWINDOWS
  SysUtils, DateUtils, Classes, TimeSpan,
  aoogenGenerator;

type
  TDateTimeStringGeneratorArg = class(TAoogenGeneratorArgs)
  private
    FHumanMode: Boolean;
    FSolidMode: Boolean;
    FDateSeparator: string;
    FTimeSeparator: string;
    FDateTimeSeparator: string;

    procedure Reset;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string; override;

    property DateSeparator: string read FDateSeparator;
    property TimeSeparator: string read FTimeSeparator;
    property DateTimeSeparator: string read FDateTimeSeparator;

    property HumanMode: Boolean read FHumanMode;
    property SolidMode: Boolean read FSolidMode;
  end;

  TDateTimeStringGenerator = class(TAoogenGenerator)
  private
    class function GenetateSolidDateTimeString: string;
    class function GenetateHumanDateTimeString: string;
    class function GenetateDateTimeString(const aArgs: TDateTimeStringGeneratorArg): string;
  public
    function GenerateValue(const aArgs: TAoogenGeneratorArgs): string; override;
  end;

implementation


{ TDateTimeStringGenerator }

function TDateTimeStringGenerator.GenerateValue(const aArgs: TAoogenGeneratorArgs): string;
var
  vArgs: TDateTimeStringGeneratorArg;
begin
  Result := GenetateSolidDateTimeString;
  if (aArgs is TDateTimeStringGeneratorArg) then begin
    vArgs := aArgs as TDateTimeStringGeneratorArg;
    if (not vArgs.SolidMode) then begin
      if (vArgs.HumanMode) then
        Result := GenetateHumanDateTimeString
      else
        Result := GenetateDateTimeString(vArgs);
    end;
  end;
end;


class function TDateTimeStringGenerator.GenetateHumanDateTimeString: string;
const
  cFmtLocalSettingsDateTime = 'yyyy/mm/dd hh:nn:ss';
begin
  Result := FormatDateTime(cFmtLocalSettingsDateTime, Now);
end;


class function TDateTimeStringGenerator.GenetateDateTimeString(const aArgs: TDateTimeStringGeneratorArg): string;
const
  cFmtDateTime = 'yyyy"%s"mm"%s"dd"%s"hh"%s"nn"%s"ss';
var
  vFmtDateTime: string;
begin
  if (Assigned(aArgs)) then begin
    vFmtDateTime := Format(cFmtDateTime, [
      aArgs.DateSeparator, aArgs.DateSeparator, aArgs.DateSeparator
    , aArgs.DateTimeSeparator
    , aArgs.TimeSeparator, aArgs.TimeSeparator, aArgs.TimeSeparator
    ]);
    Result := FormatDateTime(vFmtDateTime, Now);
  end else
    Result := GenetateSolidDateTimeString;
end;


class function TDateTimeStringGenerator.GenetateSolidDateTimeString: string;
const
  cFmtSolidDateTime = 'yyyymmddhhnnss';
begin
  Result := FormatDateTime(cFmtSolidDateTime, Now);
end;


{ TDateTimeStringGeneratorArg }

constructor TDateTimeStringGeneratorArg.Create(AOwner: TComponent);
begin
  Reset;
  FSolidMode := True;
  inherited;
end;


destructor TDateTimeStringGeneratorArg.Destroy;
begin

  inherited;
end;


procedure TDateTimeStringGeneratorArg.Reset;
begin
  FSolidMode := False;
  FHumanMode := False;
  FDateSeparator := EmptyStr;
  FTimeSeparator := EmptyStr;
end;


function TDateTimeStringGeneratorArg.SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string;
type
  TDateTimeKeyArgItem = (taiNone, taiHuman {aka "local settings"}, taiMinus, taiDot, taiSolid);

  TDateTimeKeyArgDocket = record
    Item: TDateTimeKeyArgItem;
    ShortName: string;
    LongName: string;
  end;

var
  vI: Integer;
  vParameter: string;
  vItem: TDateTimeKeyArgItem;

const
  cDateTimeDividerMinus = '-';
  cDateTimeDividerDot = '.';
  cDateTimeKeyArgArray: array[TDateTimeKeyArgItem] of TDateTimeKeyArgDocket = (
    (Item: taiNone;  ShortName: '-'; LongName: '--';)
  , (Item: taiHuman; ShortName: 'h'; LongName: 'human';)
  , (Item: taiMinus; ShortName: 'm'; LongName: 'minus';)
  , (Item: taiDot;   ShortName: 'd'; LongName: 'dot';)
  , (Item: taiSolid; ShortName: 's'; LongName: 'solid';)
  );

  function UniCase(const aString: string): string;
  begin
    Result := LowerCase(aString);
  end;

  function GetDateTimeKeyArgItem(const aStringValue: string): TDateTimeKeyArgItem;
  var
    vJ: TDateTimeKeyArgItem;
    vSuitable: Boolean;
    vValue: string;
  begin
    Result := taiNone;
    vValue := UniCase(Trim(aStringValue));
    for vJ := Low(TDateTimeKeyArgItem) to High(TDateTimeKeyArgItem) do begin
      vSuitable :=
           SameText(vValue, '-' + cDateTimeKeyArgArray[vJ].ShortName)
        or SameText(vValue, '/' + cDateTimeKeyArgArray[vJ].ShortName)
        or SameText(vValue, '--' + cDateTimeKeyArgArray[vJ].LongName);
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
      vItem := GetDateTimeKeyArgItem(vParameter);
      case (vItem) of
        taiHuman: FHumanMode := True;
        taiMinus: begin
          FDateSeparator := cDateTimeDividerMinus;
          FTimeSeparator := cDateTimeDividerMinus;
          FDateTimeSeparator := cDateTimeDividerMinus;
        end;
        taiDot: begin
          FDateSeparator := cDateTimeDividerDot;
          FTimeSeparator := cDateTimeDividerDot;
          FDateTimeSeparator := cDateTimeDividerDot;
        end;
        taiSolid: FSolidMode := True;
      end;

      vI := vI + 1;
    end;

  end;

end;

end.
