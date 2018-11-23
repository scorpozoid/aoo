program pumlxfmt;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, System.IOUtils, System.Classes;

var
  vInput: TFileName;
  vResult: string;

  function FindFile(const aFileName: TFileName): TFileName;
  var
    vFileName: TFileName;
  begin
    Result := EmptyStr;
    vFileName := aFileName;
    if (FileExists(vFileName)) then
      Result := aFileName;
    if (not TPath.IsDriveRooted(aFileName)) then begin
      vFileName := TPath.Combine(GetCurrentDir, aFileName);
      if (FileExists(vFileName)) then
        Result := aFileName;
    end;
  end;

  function LoadFileToString(const aFileName: string): string;
  var
    vStringList: TStringList;
    vJ: Integer;
    vPreview: string;
  begin
    Result := aFileName;
    vStringList := TStringList.Create;
    try
      vStringList.LoadFromFile(aFileName);
      if (0 < vStringList.Count) then begin
        vPreview := EmptyStr;
        for vJ := 0 to vStringList.Count - 1 do
          vPreview := vPreview + Trim(vStringList.Strings[vJ]);
        if (EmptyStr <> vPreview) then begin
          Result := EmptyStr;
          for vJ := 0 to vStringList.Count - 1 do begin
            Result := Result + vStringList.Strings[vJ] + '\n';
          end;
        end;
      end;
    finally
      vStringList.Free
    end;
  end;

  function IsHelpRequest(const aValue: string): Boolean;
  begin
    Result :=
      ('/?' = aValue) or
      ('/h' = aValue) or
      ('-h' = aValue) or
      ('--help' = aValue);
  end;

  // svn propset --quiet svn:keywords "Revision Date" dfpostdb-pgsql-%REVISION%.sql
  procedure PrintHelp;
  var
    vExeName: string;
  begin
    vExeName := ExtractFileName(ParamStr(0));
    Writeln(Format('%s - format text files as PlantUML note strings', [vExeName]));
    Writeln(Format('USAGE: %s filename', [vExeName]));
  end;

begin
  try
    if (1 > ParamCount) then
      Exit;
    if (IsHelpRequest(ParamStr(1))) then begin
      PrintHelp;
      Exit;
    end;
    vInput := FindFile(ParamStr(1));
    if (EmptyStr = vInput) then
      Exit;
    vResult := LoadFileToString(vInput);
    if (EmptyStr = vInput) then
      Exit;
    Writeln(vResult);
  except
    //
  end;
end.
