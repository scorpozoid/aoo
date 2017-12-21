unit aoogenGuid;

interface
uses
  SysUtils, StrUtils, Classes,
  aoogenGenerator;

type
  TGuidStringGeneratorArgs = class(TAoogenGeneratorArgs)
  public
    function SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string; override;
  end;

  TGuidStringGenerator = class(TAoogenGenerator)
  public
    class function GenetateGuidString: string;
    function GenerateValue(const aArgs: TAoogenGeneratorArgs): string; override;
  end;

implementation

{ TGuidStringGenerator }

function TGuidStringGenerator.GenerateValue(const aArgs: TAoogenGeneratorArgs): string;
begin
  Result := GenetateGuidString;
end;


class function TGuidStringGenerator.GenetateGuidString: string;
var
  vGuid: TGUID;
begin
  CreateGUID(vGuid);
  Result := GUIDToString(vGuid);
  Result := ReplaceStr(Result, '{', '');
  Result := ReplaceStr(Result, '}', '');
end;


{ TGuidStringGeneratorArgs }

function TGuidStringGeneratorArgs.SetParameters(const aParameterArray: TAoogenGeneratorParameterArray): string;
begin

end;

end.
