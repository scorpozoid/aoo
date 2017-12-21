unit aoogenHelp;

interface
uses
  SysUtils;

procedure PrintHelp;

implementation
uses
  aoogenMode;

procedure PrintHelp;
var
  vH: TModeFormat;
  vLine: string;
const
  cFmtFormatLine = '%s (%s): %s';
begin
  {$IFDEF DEBUG}
  Writeln('DEBUG VERSION');
  {$ENDIF} // DEBUG
  for vH := Low(cModeFormatArray) to High(cModeFormatArray) do begin
    vLine := Format(cFmtFormatLine, [
      LowerCase(cModeFormatArray[vH].Abbr)
    , UpperCase(cModeFormatArray[vH].Abbr)
    , cModeFormatArray[vH].Descr
    ]);
    if (EmptyStr <> cModeFormatArray[vH].Sample) then
      vLine := Format('%s (%s)', [vLine, cModeFormatArray[vH].Sample]);
    Writeln(vLine);
  end;
end;


end.
