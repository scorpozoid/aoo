@echo off
rem
rem
rem

cls

set HOME=C:\home\%USERNAME%
set PATH=%PATH%;%HOME%\bin\python-2.7.6.1\App
set PATH=%PATH%;%HOME%\devel\shell\media

if exist jmsort.log del jmsort.log
echo "jmsort start: %DATE% %TIME%" > jmsort.log

rem FAIL -- Юлия Александровна -- python jmsort.py -i "D:\alb\temp\1_2018-temp\00\Юлия Александровна" -o C:\home\ark\temp\jmsort 
python jmsort.py -i D:\alb\temp\1_2018-temp -i "D:\alb\photo\2017" -i "D:\alb\photo\2016" -x D:\alb\temp\1_2018-temp\05\temp-2014-summer\best\_2_GALTAB-2 -x D:\alb\temp\1_2018-temp\05\temp-2014-summer\best\_2_GALTAB -o C:\home\ark\temp\jmsort --mode=touch
rem python jmsort.py -i C:\home\ark\photo -o C:\home\ark\temp\jmsort --mode=copy

rem python jmsort.py -i D:\alb\temp -o C:\home\ark\temp\jmsort --mode=touch

echo "jmsort finish: %DATE% %TIME%" >> jmsort.log

pause

rem EOF
