@echo off

set HOMEBIN=c:\home\%USERNAME%\bin
set HOMESHARE=c:\home\%USERNAME%\temp\share

set PATH=%PATH%;%PROGRAMFILES%\Borland\BDS\4.0\Bin
set PATH=%PATH%;%PROGRAMFILES(X86)%\Borland\BDS\4.0\Bin
set PATH=%PATH%;%PROGRAMFILES%\Embarcadero\RAD Studio\10.0\bin
set PATH=%PATH%;%PROGRAMFILES(X86)%\Embarcadero\RAD Studio\10.0\bin
set PATH=%PATH%;%PROGRAMFILES%\TortoiseSVN\bin
rem set PATH=%PATH%;%WINDIR%\Microsoft.NET\Framework\v2.0.50727\
set PATH=%PATH%;%WINDIR%\Microsoft.NET\Framework\v3.5\

call rsvars.bat 

msbuild aoogen.dproj "/t:clean;build" "/p:Config=Release"
rem msbuild aoogen.dproj "/t:clean;build" "/p:Config=Debug"

if exist *.dcu del *.dcu
if exist *.local del *.local
if exist *.identcache del *.identcache
if exist *.res del *.res

pause

rem EOF