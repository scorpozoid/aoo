unit aoogenMode;

interface
uses
  SysUtils;

type
  TModeFormatDocket = record
    Abbr: string;
    Title: string;
    Sample: string;
    Descr: string;
  end;

  TModeFormat = (
    ofNone
  , ofGuid
  , ofDate
  , ofTime
  , ofDateTime
  , ofTimestamp
  , ofUnixTime
  , ofRandom
  );

const
  cModeFormatArray: array [TModeFormat] of TModeFormatDocket = (
    (Abbr:   'N';  Title: 'none';      Sample: '';                                     Descr: 'empty string')
  , (Abbr:   'G';  Title: 'guid';      Sample: '9F41170C-D8E2-4282-B164-BE813D89D015'; Descr: 'GUID without curly braces')
  , (Abbr:   'D';  Title: 'date';      Sample: '1970-01-01';                           Descr: '')
  , (Abbr:   'T';  Title: 'time';      Sample: '23.59.59';                             Descr: '')
  , (Abbr:  'DT';  Title: 'datetime';  Sample: '1970/01/01 23:59:59';                  Descr: '')
  , (Abbr:  'TS';  Title: 'timestamp'; Sample: '19700101235959001';                    Descr: '')
  , (Abbr:  'UT';  Title: 'unixtime';  Sample: '10';                                   Descr: '')
  , (Abbr: 'RND';  Title: 'random';    Sample: '1234';                                 Descr: '')
  );

function GetModeFormat(const aStringValue: string): TModeFormat;

implementation

function GetModeFormat(const aStringValue: string): TModeFormat;
var
  vI: TModeFormat;
  vSuitable: Boolean;
  vValue: string;
  vAbbr, vTitle: string;

  function UniCase(const aValue: string): string;
  begin
    Result := LowerCase(aValue);
  end;

begin
  Result := ofNone;
  vValue := UniCase(Trim(aStringValue));
  for vI := Low(cModeFormatArray) to High(cModeFormatArray) do begin
    vAbbr := UniCase(cModeFormatArray[vI].Abbr);
    vTitle := UniCase(cModeFormatArray[vI].Title);
    vSuitable :=
         SameText(vValue, vAbbr)
      or SameText(vValue, vTitle);
    if (vSuitable) then begin
      Result := vI;
      Break;
    end;
  end;
end;



end.
