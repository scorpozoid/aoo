unit aoogenUnixtime;

interface
uses
  SysUtils, DateUtils, Classes,
  aoogenGenerator;

type
  TUnixtimeStringGenerator = class(TAoogenGenerator)
  private
    class function GetUnixtime: Int64;
  public
    class function GenetateUnixtimeString: string;
    function GenerateValue(const aArgs: TAoogenGeneratorArgs): string; override;
  end;

implementation


{ TUnixtimeStringGenerator }

function TUnixtimeStringGenerator.GenerateValue(const aArgs: TAoogenGeneratorArgs): string;
begin
  Result := GenetateUnixtimeString;
end;


class function TUnixtimeStringGenerator.GenetateUnixtimeString: string;
begin
  Result := IntToStr(GetUnixtime);
end;


class function TUnixtimeStringGenerator.GetUnixtime: Int64;
begin
  Result := SecondsBetween(
    Now,
    EncodeDateTime(1970, 1, 1, 0, 0, 0, 0)
  );
end;

end.