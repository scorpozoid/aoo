@echo off

set pwd=%cd%
cd %~dp0

set PATH=%WINDIR%\Microsoft.NET\Framework\v4.0.30319;%PATH%

call rsvars.bat

msbuild pumlxfmt.dproj /t:build /v:minimal /p:config="Release"

cd %pwd%

pause

rem EOF