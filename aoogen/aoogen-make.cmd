@echo off

set HOMEBIN=c:\home\%USERNAME%\bin
set HOMESHARE=c:\home\%USERNAME%\temp\share

set PATH=%PATH%;%PROGRAMFILES%\Borland\BDS\4.0\Bin
set PATH=%PATH%;%PROGRAMFILES(X86)%\Borland\BDS\4.0\Bin
set PATH=%PATH%;%PROGRAMFILES%\Embarcadero\RAD Studio\10.0\bin
set PATH=%PATH%;%PROGRAMFILES(X86)%\Embarcadero\RAD Studio\10.0\bin
rem set PATH=%PATH%;%PROGRAMFILES%\TortoiseSVN\bin
rem set PATH=%PATH%;%WINDIR%\Microsoft.NET\Framework\v2.0.50727
set PATH=%PATH%;%WINDIR%\Microsoft.NET\Framework\v3.5

set PATH=%PATH%;%HOMEBIN%\gitpack-2017.11.22\git-2.15.1.2\bin

setlocal enabledelayedexpansion

set GIT_EXE_FOUND=
for %%e in (%PATHEXT%) do (
  for %%X in (git%%e) do (
    if not defined GIT_EXE_FOUND (
      set GIT_EXE_FOUND=%%~$PATH:X
    )
  )
)

if defined GIT_EXE_FOUND (
  echo git binaries found

  set githash=
  for /F %%H in ('git rev-parse HEAD') do set githash=%%H 
  echo !githash!

  rem set gittimestamp=
  rem for /F %%T in ('git log -1 --format=^%cd --date=unix') do set gittimestamp=%%T 
  rem echo !gittimestamp!
  rem git log -1 --format=%cd --date=unix > aoogen.revision
  rem rfc2822  

  if exist .\aoogenVersion.inc del .\aoogenVersion.inc
  rem > .\aoogenVersion.inc echo Writeln^('0.0.1, ^(!githash!^)'^);
  > .\aoogenVersion.inc echo Writeln^('0.0.1, !githash!'^);
)

call rsvars.bat 

msbuild aoogen.dproj "/t:clean;build" "/p:Config=Release"
rem msbuild aoogen.dproj "/t:clean;build" "/p:Config=Debug"

if exist *.dcu del *.dcu
if exist *.local del *.local
if exist *.identcache del *.identcache
if exist *.res del *.res

if exist .\aoogenVersion.inc del .\aoogenVersion.inc
> .\aoogenVersion.inc echo //


pause

rem EOF