(*
  
  Find special tags 
  (like {{FILE:somefile.ext}})
  in PlantUML diagrams
  and replace them with content of specified file (somefile.ext)
  formatted as PlantUML notes.

  SEEMS FAIL! NOT USABLE!

  USE pumlxfmt.exe instead!

*)

program pumlprep;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, System.StrUtils, System.Classes;

var
  vExePath: TFileName;
  vTemplatePath: TFileName;
  vReplace, vExt: string;
  vTemplate: TFileName;
  vResult: TFileName;
  vLines, vResultLines: TStringList;
  vLine: string;
  vL: Integer;

  const
    cPrefix = '{{FILE:';
    cPostfix = '}}';

//  function ExcludeLeadingPathDelimiter(const S: string): string;
//  begin
//    Result := S;
//    if IsPathDelimiter(Result, High(Result)) then
//      SetLength(Result, Length(Result)-1);
//  end;
//
//
//  function GetFileName(const aFileName: TFileName): TFileName;
//  begin
//    Result := '';
//    if (EmptyStr <> ExtractFileDrive(aFileName)) then
//      Result := aFileName
//    else if FileExists(IncludeTrailingPathDelimiter(vPath) + aFileName) then
//    remo
//      Result := aFileName
//    Exit;
//  end;

  function FindFile(const aFileName: TFileName): TFileName;
  var
    vFileName: TFileName;
  begin
    Result := EmptyStr;
    vFileName := aFileName;
    if (FileExists(vFileName)) then
      Result := aFileName;
    vFileName := IncludeTrailingPathDelimiter(GetCurrentDir) + aFileName;
    if (FileExists(vFileName)) then
      Result := aFileName;
  end;

  procedure CheckInput;
  begin
    if 2 > ParamCount then
      raise Exception.CreateFmt('Param insuffience %d', [ParamCount]);
    if not FileExists(FindFile(ParamStr(1))) then
      raise Exception.CreateFmt('File doesn''t exists: %s', [ParamStr(1)]);
    if ((EmptyStr <> ExtractFileDir(ParamStr(2))) and (not DirectoryExists(ExtractFileDir(ParamStr(2))))) then
      raise Exception.CreateFmt('Target folder doesn''t exists for: %s', [ParamStr(2)]);
  end;

  function ExtractExtFile(const aLine: string): TFileName;
  var
    vFound: Boolean;
    vX1, vX2: Integer;
  begin
    Result := EmptyStr;
    vX1 := Pos(cPrefix, vLine);
    vX2 := Pos(cPostfix, vLine);
    vFound :=
      (Low(string) <= vX1) and
      (Low(string) <= vX2);
    if (vFound) then
      Result := Copy(aLine, vX1 + Length(cPrefix), vX2 - vX1 - Length(cPrefix));
  end;

  function LoadExtFileAsLine(const aFileName: string): string;
  var
    vFileName: TFileName;
    vStringList: TStringList;
    vJ: Integer;
    vPreview: string;
  begin
    Result := aFileName;
    vFileName := aFileName;
    if (not FileExists(vFileName)) then begin
      vFileName := vTemplatePath + vFileName;
      if (not FileExists(vFileName)) then
        Exit;
    end;
    vStringList := TStringList.Create;
    try
      vStringList.LoadFromFile(vFileName);
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

begin
  try
    vExePath := ExtractFileDir(ParamStr(0));

    CheckInput;
    vTemplate := ParamStr(1);
    vTemplatePath := IncludeTrailingPathDelimiter(ExtractFileDir(vTemplate));
    vResult := ParamStr(2);

    vLines := TStringList.Create;
    try
      vResultLines := TStringList.Create;
      try
        vLines.LoadFromFile(vTemplate);
        for vL := 0 to vLines.Count - 1 do begin
          vLine := vLines.Strings[vL];
          vExt := ExtractExtFile(vLine);
          while EmptyStr <> vExt do begin
            vReplace := LoadExtFileAsLine(vExt);
            vLine := ReplaceStr(vLine, cPrefix + vExt + cPostfix, vReplace);
            vExt := ExtractExtFile(vLine);
          end;
          vResultLines.Add(vLine);
        end;
        vResultLines.SaveToFile(vResult);
      finally
        vResultLines.Free;
      end;
    finally
      vLines.Free;
    end;

  except
    on E: Exception do begin
      Writeln(E.ClassName, ': ', E.Message);
    end;
  end;
end.
