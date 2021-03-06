unit aoogenFactory;

interface
uses
  SysUtils, Classes,
  aoogenMode,
  aoogenGenerator,
  aoogenDate,
  aoogenTime,
  aoogenDateTime,
  aoogenTimestamp,
  aoogenUnixtime,
  aoogenRandom,
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
    ofDate: Result := TDateStringGenerator.Create(nil);
    ofTime: Result := TTimeStringGenerator.Create(nil);
    ofDateTime: Result := TDateTimeStringGenerator.Create(nil);
    ofTimestamp: Result := TTimestampStringGenerator.Create(nil);
    ofUnixTime: Result := TUnixtimeStringGenerator.Create(nil);
    ofRandom: Result := TRandomStringGenerator.Create(nil);
  else
    Result := nil;
  end;
end;


function TAoogenFactory.BuildGeneratorArgs: TAoogenGeneratorArgs;
begin
  case (FMode) of
    ofNone: Result := nil;
    ofGuid: Result := TGuidStringGeneratorArg.Create(nil);
    ofDate: Result := TDateStringGeneratorArg.Create(nil);
    ofTime: Result := TTimeStringGeneratorArg.Create(nil);
    ofDateTime: Result := TDateTimeStringGeneratorArg.Create(nil);
    ofTimestamp: Result := TTimestampStringGeneratorArg.Create(nil);
    ofUnixTime: Result := nil;
    ofRandom: Result := TRandomStringGeneratorArg.Create(nil);
  else
    Result := nil;
  end;
end;

end.
