unit aoogenFactory;

interface
uses
  SysUtils, Classes,
  aoogenMode,
  aoogenGenerator,
  aoogenUnixtime,
  aoogenTimestamp,
  aoogenGuid;

type
  TAoogenFactory = class(TComponent)
  private
    FMode: TModeFormat;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function BuildGeneratorArgs: TAoogenGeneratorArgs;
    function BuildGenerator: TAoogenGenerator;

    property Mode: TModeFormat read FMode write FMode;
  end;

implementation


{ TAoogenFactory }

constructor TAoogenFactory.Create(AOwner: TComponent);
begin
  FMode := ofNone;
  inherited;

end;


destructor TAoogenFactory.Destroy;
begin

  inherited;
end;


function TAoogenFactory.BuildGenerator: TAoogenGenerator;
begin
  case (FMode) of
    ofNone: Result := nil;
    ofGuid: Result := TGuidStringGenerator.Create(nil);
//    ofDate: vResult := TGuidStringGenerator.GenetateGuidString;
//    ofTime
//    ofDateTime
    ofTimestamp: Result := TTimestampStringGenerator.Create(nil);
    ofUnixTime: Result := TUnixtimeStringGenerator.Create(nil);
//    ofRandom
  else
    Result := nil;
  end;
end;


function TAoogenFactory.BuildGeneratorArgs: TAoogenGeneratorArgs;
begin
  case (FMode) of
    ofNone: Result := nil;
    ofGuid: Result := TGuidStringGeneratorArgs.Create(nil);
//    ofDate: vResult := TGuidStringGenerator.GenetateGuidString;
//    ofTime
//    ofDateTime
    ofTimestamp: Result := TTimestampStringGeneratorArg.Create(nil);
    ofUnixTime: Result := nil;
//    ofRandom
  else
    Result := nil;
  end;
end;

end.
