unit aoogenTime;

interface
uses
  SysUtils, DateUtils, Classes,
  aoogenGenerator;

type
  TTimeStringGeneratorArg = class(TAoogenGeneratorArgs)
  strict private
    FSolidMode: Boolean;
    FSeparator: string;
    procedure Reset;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string; override;

    property Separator: string read FSeparator;
    property SolidMode: Boolean read FSolidMode;
  end;

  TTimeStringGenerator = class(TAoogenGenerator)
  private
    class function GenetateTimeString(const aArgs: TTimeStringGeneratorArg): string;
  public
    function GenerateValue(const aArgs: TAoogenGeneratorArgs): string; override;
  end;

implementation


{ TTimeStringGenerator }

function TTimeStringGenerator.GenerateValue(const aArgs: TAoogenGeneratorArgs): string;
var
  vArgs: TTimeStringGeneratorArg;
begin
  Result := GenetateTimeString(nil);
  if (aArgs is TTimeStringGeneratorArg) then begin
    vArgs := aArgs as TTimeStringGeneratorArg;
    if (not vArgs.SolidMode) then
      Result := GenetateTimeString(vArgs);
  end;
end;


class function TTimeStringGenerator.GenetateTimeString(const aArgs: TTimeStringGeneratorArg): string;
const
  cFmtTime = 'hh"%s"nn"%s"ss';
  cFmtSolidTime = 'hhnnss';
var
  vFmtTime: string;
begin
  Result := EmptyStr;
  if (Assigned(aArgs)) then begin
    if (EmptyStr <> aArgs.Separator) then begin
      vFmtTime := Format(cFmtTime, [
        aArgs.Separator, aArgs.Separator
      ]);
      Result := FormatDateTime(vFmtTime, Now);
    end
  end;
  if (EmptyStr = Result) then
    Result := FormatDateTime(cFmtSolidTime, Now);
end;


{ TTimeStringGeneratorArg }

constructor TTimeStringGeneratorArg.Create(AOwner: TComponent);
begin
  Reset;
  FSolidMode := True;
  inherited;
end;


destructor TTimeStringGeneratorArg.Destroy;
begin

  inherited;
end;


procedure TTimeStringGeneratorArg.Reset;
begin
  FSolidMode := False;
  FSeparator := EmptyStr;
end;


function TTimeStringGeneratorArg.SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string;
type
  TTimeKeyArgItem = (tkaiNone, tkaiColon, tkaiMinus, tkaiDot, tkaiSolid);

  TTimeKeyArgDocket = record
    Item: TTimeKeyArgItem;
    ShortName: string;
    LongName: string;
  end;

var
  vI: Integer;
  vParameter: string;
  vItem: TTimeKeyArgItem;

const
  cTimeDividerMinus = '-';
  cTimeDividerDot = '.';
  cTimeDividerColon = ':';
  cTimeDividerNone = '';
  cTimeKeyArgArray: array[TTimeKeyArgItem] of TTimeKeyArgDocket = (
    (Item: tkaiNone;  ShortName: '-'; LongName: '--';)
  , (Item: tkaiColon; ShortName: 'l'; LongName: 'colon';)
  , (Item: tkaiMinus; ShortName: 'm'; LongName: 'minus';)
  , (Item: tkaiDot;   ShortName: 'd'; LongName: 'dot';)
  , (Item: tkaiSolid; ShortName: 's'; LongName: 'solid';)
  );

  function UniCase(const aString: string): string;
  begin
    Result := LowerCase(aString);
  end;

  function GetTimeKeyArgItem(const aStringValue: string): TTimeKeyArgItem;
  var
    vJ: TTimeKeyArgItem;
    vSuitable: Boolean;
    vValue: string;
  begin
    Result := tkaiNone;
    vValue := UniCase(Trim(aStringValue));
    for vJ := Low(TTimeKeyArgItem) to High(TTimeKeyArgItem) do begin
      vSuitable :=
           SameText(vValue, '-' + cTimeKeyArgArray[vJ].ShortName)
        or SameText(vValue, '/' + cTimeKeyArgArray[vJ].ShortName)
        or SameText(vValue, '--' + cTimeKeyArgArray[vJ].LongName);
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
      vItem := GetTimeKeyArgItem(vParameter);
      case (vItem) of
        tkaiColon: FSeparator := cTimeDividerColon;
        tkaiMinus: FSeparator := cTimeDividerMinus;
        tkaiDot: FSeparator := cTimeDividerDot;
        tkaiSolid: FSolidMode := True;
      end;
      vI := vI + 1;
    end;

  end;

end;

end.
