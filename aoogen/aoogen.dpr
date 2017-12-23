program aoogen;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  aoogenGuid in 'aoogenGuid.pas',
  aoogenUnixtime in 'aoogenUnixtime.pas',
  aoogenFactory in 'aoogenFactory.pas',
  aoogenGenerator in 'aoogenGenerator.pas',
  aoogenMode in 'aoogenMode.pas',
  aoogenHelp in 'aoogenHelp.pas',
  aoogenTimestamp in 'aoogenTimestamp.pas',
  aoogenRandom in 'aoogenRandom.pas',
  aoogenDateTime in 'aoogenDateTime.pas';

type
  TCliParamArray = array of string;

var
  vResult: string;
  vModeFormat: TModeFormat;
  vAoogenFactory: TAoogenFactory;
  vArgs: TAoogenGeneratorArgs;
  vGenerator: TAoogenGenerator;
  vParameterArray: TAoogenGeneratorParameterArray;

  function PrepareParameterArray: TAoogenGeneratorParameterArray;
  var
    vI: Integer;
    vParameter: string;
  begin
    Result := nil;
    if (0 < ParamCount) then begin
      for vI := 1 to ParamCount do begin
        vParameter := ParamStr(vI);
        SetLength(Result, Length(Result) + 1);
        Result[Length(Result) - 1] := vParameter;
      end;
    end;
  end;

begin
  try
    vResult := EmptyStr;
    vParameterArray := PrepareParameterArray;
    if (0 < Length(vParameterArray)) then try
      vModeFormat := GetModeFormat(vParameterArray[0]);
      if (ofNone <> vModeFormat) then begin
        vAoogenFactory := TAoogenFactory.Create(nil);
        try
          vAoogenFactory.Mode := vModeFormat;
          vArgs := vAoogenFactory.BuildGeneratorArgs;
          try
            if (Assigned(vArgs)) then
              vArgs.SetParameters(vParameterArray);
            vGenerator := vAoogenFactory.BuildGenerator;
            if (Assigned(vGenerator)) then
              vResult := vGenerator.GenerateValue(vArgs);
          finally
            if (Assigned(vArgs)) then
              vArgs.Free;
          end;
        finally
          vAoogenFactory.Free;
        end;
      end;
    finally
      vParameterArray := nil;
    end;
    if (EmptyStr <> vResult) then
      Writeln(vResult)
    else
      PrintHelp;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
