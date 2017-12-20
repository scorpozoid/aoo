unit aoogenGuid;

interface
uses
  SysUtils, StrUtils, Classes;

type
  TGuidStringGenerator = class(TComponent)
  public
    class function GenetateGuidString: string;
  end;

implementation

{ TGuidStringGenerator }

class function TGuidStringGenerator.GenetateGuidString: string;
var
  vGuid: TGUID;
begin
  CreateGUID(vGuid);
  Result := GUIDToString(vGuid);
  Result := ReplaceStr(Result, '{', '');
  Result := ReplaceStr(Result, '}', '');
end;

end.
