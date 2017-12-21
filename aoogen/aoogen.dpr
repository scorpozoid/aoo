program aoogen;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  aoogenGuid in 'aoogenGuid.pas',
  aoogenUnixtime in 'aoogenUnixtime.pas';

type
  TOutputFormatDocket = record
    Abbr: string;
    Title: string;
    Sample: string;
    Descr: string;
  end;

  TOutputFormat = (
    ofNone
  , ofGuid
  , ofDate
  , ofTime
  , ofDateTime
  , ofTimestamp
  , ofUnixTime
  , ofRandom
  );

var
  vResult: string;
  vParameter: string;
  vOutputFormat: TOutputFormat;

const
  cFormatCount = 1;

  cFormatArray: array [TOutputFormat] of TOutputFormatDocket = (
    (Abbr: 'N'; Title: 'NONE'; Sample: ''; Descr: 'empty string')
  , (Abbr: 'G'; Title: 'GUID'; Sample: '9F41170C-D8E2-4282-B164-BE813D89D015'; Descr: 'GUID without curly braces')
  , (Abbr: '';  Title: ''; Sample: ''; Descr: '')
  , (Abbr: '';  Title: ''; Sample: ''; Descr: '')
  , (Abbr: '';  Title: ''; Sample: ''; Descr: '')
  , (Abbr: '';  Title: ''; Sample: ''; Descr: '')
  , (Abbr: '';  Title: ''; Sample: ''; Descr: '')
  , (Abbr: '';  Title: ''; Sample: ''; Descr: '')
  );

  procedure PrintHelp;
  var
    vH: TOutputFormat;
    vLine: string;
  const
    cFmtFormatLine = '%s (%s): %s';
  begin
    {$IFDEF DEBUG}
    Writeln('DEBUG VERSION');
    {$ENDIF} // DEBUG
    for vH := Low(cFormatArray) to High(cFormatArray) do begin
      vLine := Format(cFmtFormatLine, [
        LowerCase(cFormatArray[vH].Abbr)
      , UpperCase(cFormatArray[vH].Abbr)
      , cFormatArray[vH].Descr
      ]);
      if (EmptyStr <> cFormatArray[vH].Sample) then
        vLine := Format('%s (%s)', [vLine, cFormatArray[vH].Sample]);
      Writeln(vLine);
    end;
  end;

  function GetOutputFormat(const aStringValue: string): TOutputFormat;
  var
    vI: TOutputFormat;
    vSuitable: Boolean;
    vValue: string;
  begin
    Result := ofNone;
    vValue := Trim(aStringValue);
    for vI := Low(cFormatArray) to High(cFormatArray) do begin
      vSuitable :=
           SameText(vValue, cFormatArray[vI].Abbr)
        or SameText(vValue, '-' + cFormatArray[vI].Abbr)
        {$IFDEF MSWINDOWS}
        or SameText(vValue, '/' + cFormatArray[vI].Abbr)
        {$ENDIF} // MSWINDOWS
        ;
      if (vSuitable) then begin
        Result := vI;
        Break;
      end;
    end;
  end;

begin
  try
    vResult := EmptyStr;
    if (0 < ParamCount) then begin
      vParameter := ParamStr(1);
      vOutputFormat := GetOutputFormat(vParameter);
      case (vOutputFormat) of
        ofNone: vResult := EmptyStr;
        ofGuid: vResult := TGuidStringGenerator.GenetateGuidString;
      else
        vResult := EmptyStr;
      end;
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
