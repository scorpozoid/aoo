unit aoogenTimestamp;

interface
uses
  SysUtils, DateUtils, Classes,
  aoogenGenerator;

type
  TTimestampStringGeneratorArg = class(TAoogenGeneratorArgs)
  public
    function SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string; override;
  end;

  TTimestampStringGenerator = class(TAoogenGenerator)
  public
    class function GenetateTimestampString: string;
    function GenerateValue(const aArgs: TAoogenGeneratorArgs): string; override;
  end;

implementation


{ TTimestampStringGenerator }

function TTimestampStringGenerator.GenerateValue(const aArgs: TAoogenGeneratorArgs): string;
begin
  Result := GenetateTimestampString;
end;


class function TTimestampStringGenerator.GenetateTimestampString: string;
begin
  Result := IntToStr(GetTimestamp);
end;


end.
