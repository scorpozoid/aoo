unit aoogenDate;

interface
uses
  SysUtils, DateUtils, Classes, TimeSpan,
  aoogenGenerator;

type
  TDateStringGeneratorArg = class(TAoogenGeneratorArgs)
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

  TDateStringGenerator = class(TAoogenGenerator)
  private
    class function GenetateDateString(const aArgs: TDateStringGeneratorArg): string;
  public
    function GenerateValue(const aArgs: TAoogenGeneratorArgs): string; override;
  end;

implementation


{ TDateStringGenerator }

function TDateStringGenerator.GenerateValue(const aArgs: TAoogenGeneratorArgs): string;
var
  vArgs: TDateStringGeneratorArg;
begin
  Result := GenetateDateString(nil);
  if (aArgs is TDateStringGeneratorArg) then begin
    vArgs := aArgs as TDateStringGeneratorArg;
    if (not vArgs.SolidMode) then
      Result := GenetateDateString(vArgs);
  end;
end;


class function TDateStringGenerator.GenetateDateString(const aArgs: TDateStringGeneratorArg): string;
const
  cFmtDate = 'yyyy"%s"mm"%s"dd';
  cFmtSolidDate = 'yyyymmdd';
var
  vFmtDate: string;
begin
  Result := EmptyStr;
  if (Assigned(aArgs)) then begin
    if (EmptyStr <> aArgs.Separator) then begin
      vFmtDate := Format(cFmtDate, [
        aArgs.Separator, aArgs.Separator
      ]);
      Result := FormatDateTime(vFmtDate, Now);
    end
  end;
  if (EmptyStr = Result) then
    Result := FormatDateTime(cFmtSolidDate, Now);
end;


{ TDateStringGeneratorArg }

constructor TDateStringGeneratorArg.Create(AOwner: TComponent);
begin
  Reset;
  FSolidMode := True;
  inherited;
end;


destructor TDateStringGeneratorArg.Destroy;
begin

  inherited;
end;


procedure TDateStringGeneratorArg.Reset;
begin
  FSolidMode := False;
  FSeparator := EmptyStr;
end;


function TDateStringGeneratorArg.SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string;
type
  TDateKeyArgItem = (dkaiNone, dkaiSlash, dkaiMinus, dkaiDot, dkaiSolid);

  TDateKeyArgDocket = record
    Item: TDateKeyArgItem;
    ShortName: string;
    LongName: string;
  end;

var
  vI: Integer;
  vParameter: string;
  vItem: TDateKeyArgItem;

const
  cDateDividerMinus = '-';
  cDateDividerDot = '.';
  cDateDividerSlash = '/';
  cDateDividerNone = '';
  cDateKeyArgArray: array[TDateKeyArgItem] of TDateKeyArgDocket = (
    (Item: dkaiNone;  ShortName: '-'; LongName: '--';)
  , (Item: dkaiSlash; ShortName: 'l'; LongName: 'slash';)
  , (Item: dkaiMinus; ShortName: 'm'; LongName: 'minus';)
  , (Item: dkaiDot;   ShortName: 'd'; LongName: 'dot';)
  , (Item: dkaiSolid; ShortName: 's'; LongName: 'solid';)
  );

  function UniCase(const aString: string): string;
  begin
    Result := LowerCase(aString);
  end;

  function GetDateKeyArgItem(const aStringValue: string): TDateKeyArgItem;
  var
    vJ: TDateKeyArgItem;
    vSuitable: Boolean;
    vValue: string;
  begin
    Result := dkaiNone;
    vValue := UniCase(Trim(aStringValue));
    for vJ := Low(TDateKeyArgItem) to High(TDateKeyArgItem) do begin
      vSuitable :=
           SameText(vValue, '-' + cDateKeyArgArray[vJ].ShortName)
        or SameText(vValue, '/' + cDateKeyArgArray[vJ].ShortName)
        or SameText(vValue, '--' + cDateKeyArgArray[vJ].LongName);
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
      vItem := GetDateKeyArgItem(vParameter);
      case (vItem) of
        dkaiSlash: FSeparator := cDateDividerSlash;
        dkaiMinus: FSeparator := cDateDividerMinus;
        dkaiDot: FSeparator := cDateDividerDot;
        dkaiSolid: FSolidMode := True;
      end;
      vI := vI + 1;
    end;

  end;

end;

end.
