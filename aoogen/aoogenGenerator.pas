unit aoogenGenerator;

interface
uses
  SysUtils, Classes;

type
  TAoogenGeneratorParameterArray = array of string;

  TAoogenGeneratorArgs = class(TComponent)
  public
    function SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string; virtual;
  end;

  TAoogenGenerator = class(TComponent)
  public
    function GenerateValue(const aArgs: TAoogenGeneratorArgs): string; virtual;
  end;

implementation


{ TAoogenGeneratorArgs }

function TAoogenGeneratorArgs.SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string;
begin
  //
end;


{ TAoogenGenerator }

function TAoogenGenerator.GenerateValue(const aArgs: TAoogenGeneratorArgs): string;
begin
 //
end;


end.

