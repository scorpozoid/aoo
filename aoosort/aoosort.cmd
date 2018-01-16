@echo off
rem
rem
rem

cls

set HOME=C:\home\%USERNAME%
set PATH=%PATH%;%HOME%\bin\python-2.7.6.1\App
set PATH=%PATH%;%HOME%\devel\shell\media

if exist aoosort.log del aoosort.log
echo "aoosort start: %DATE% %TIME%" > aoosort.log

rem FAIL -- Юлия Александровна -- python aoosort.py -i "D:\alb\temp\1_2018-temp\00\Юлия Александровна" -o C:\home\ark\temp\aoosort 
rem python aoosort.py -i D:\alb\temp\1_2018-temp -i "D:\alb\photo\2017" -i "D:\alb\photo\2016" -x D:\alb\temp\1_2018-temp\05\temp-2014-summer\best\_2_GALTAB-2 -x D:\alb\temp\1_2018-temp\05\temp-2014-summer\best\_2_GALTAB -o C:\home\ark\temp\aoosort --mode=touch
rem python aoosort.py -i C:\home\ark\photo -o C:\home\ark\temp\aoosort --mode=copy

python aoosort.py ^
  --mode=move ^
  -o D:\alb\photo-aoosort ^
  ^
  -i D:\alb\temp\01_2018-temp ^
  -i D:\alb\temp\02_2018-temp ^
  -i D:\alb\temp\03_2018-temp ^
  ^
  -x D:\alb\temp\01_2018-temp\upload ^
  -x D:\alb\temp\01_2018-temp\2014-08-00-galaxy-tab-web 

rem python aoosort.py -i D:\alb\temp -o C:\home\ark\temp\aoosort --mode=touch

echo "aoosort finish: %DATE% %TIME%" >> aoosort.log

pause

rem EOF
