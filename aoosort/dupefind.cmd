@echo off
rem
rem
rem

cls

set HOME=C:\home\%USERNAME%
set PATH=%PATH%;%HOME%\bin\python-2.7.6.1\App
set PATH=%PATH%;%HOME%\devel\shell\media


python dupefind.py ^
  --mode=notice ^
  -i "D:\alb\photo\2012\2012.09.00 Сентябрь" ^
  -i "D:\alb\photo\2012\2012.10.00 Октябрь" ^
  -i "D:\alb\photo\2012\2012.11.00 Ноябрь" ^
  -i "D:\alb\photo\2012\2012.12.00 Декабрь" ^
  -i D:\alb\photo\2013 ^
  -i D:\alb\photo\2014 ^
  -i D:\alb\photo\2015 ^
  -i D:\alb\photo\2016 ^
  -i D:\alb\photo\2017 ^
  -i D:\alb\photo\2018 ^
  -x "D:\alb\photo\2016\2016.04.00 Апрель\2016.04.02" ^
  -x "D:\alb\photo\2012\2012.06.00 Июнь\2012.06.02 Just 10 years married" ^
  -b %HOME%\temp\aoodupe

pause
  
rem EOF
