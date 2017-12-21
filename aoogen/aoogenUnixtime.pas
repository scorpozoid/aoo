unit aoogenUnixtime;

interface
uses
  SysUtils, DateUtils, Classes;

type
  TUnixtimeStringGenerator = class(TComponent)
  private
    class function GetUnixtime: Int64;
  public
    class function GenetateUnixtimeString: string;
  end;

implementation


{ TUnixtimeStringGenerator }

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