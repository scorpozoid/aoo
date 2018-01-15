@echo off
rem
rem
rem

cls

set HOME=C:\home\%USERNAME%
set PATH=%PATH%;%HOME%\bin\python-2.7.6.1\App
set PATH=%PATH%;%HOME%\devel\shell\media

python jsort.py 

pause

rem EOF
