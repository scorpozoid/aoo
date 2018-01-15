@rem 
@rem 
@rem 

@set PATH=%PATH%;.\Win32\Release
@set PATH=%PATH%;.\Win32\Debug

aoogen none 

aoogen unixtime

aoogen timestamp
aoogen timestamp -h
aoogen timestamp --human
aoogen timestamp -i
aoogen timestamp --iso
aoogen ts --minus
aoogen ts -m
aoogen ts --dot
aoogen ts -d
aoogen timestamp -s
aoogen timestamp --solid
aoogen timestamp -h --iso -m --dot --solid

rem uuidgen
rem powershell -Command "[guid]::NewGuid().ToString()"
rem cmd /c powershell.exe -Command "[guid]::NewGuid().ToString()"
aoogen guid
aoogen guid -m
aoogen guid -s
aoogen g -s -b
aoogen g -m -b
aoogen g -m --curlybrace
aoogen g -d --curlybrace
aoogen g -d --curlybrace --solid
aoogen guid --solid --lower
aoogen guid --colon --lower

aoogen guid --solid --wrap="curlybrace,                 squarebraces, singlequote, doublequote"
aoogen guid --solid --wrap=curlybrace,squarebraces,singlequote,doublequote
aoogen guid --solid --wrap curlybrace,squarebraces,singlequote,doublequote
aoogen guid --solid --w curlybrace,squarebraces,singlequote,doublequote
aoogen guid --solid --wrap 
aoogen guid --solid --wrap=
aoogen guid --wrap --solid  
aoogen guid --wrap= --solid
aoogen guid -w --solid
aoogen guid -w ab,dq --lowercase --minus

aoogen random -r 100000 -o -1000 --zero-padding
aoogen random --zero-padding --range=10000 -o
aoogen rnd --offset=-1000 --space-padding --range=3000000000
aoogen rnd --offset=3000000000 --space-padding --range=100
aoogen rnd --offset=3000000000 --space-padding --range=
aoogen random -r
aoogen random

aoogen datetime --human
aoogen datetime --minus
aoogen datetime --solid
aoogen datetime --dot 
aoogen datetime --dot --solid
aoogen dt -m -d -s
aoogen dt -m -s -d

aoogen date --human
aoogen date --minus
aoogen date --solid
aoogen date --slash
aoogen date --dot 
aoogen date --dot --solid
aoogen d -m -d -s
aoogen d -m -s -d
aoogen d -m -s -l
aoogen d -l

aoogen time --human
aoogen time --minus
aoogen time --solid
aoogen time --slash
aoogen time --colon
aoogen time --dot 
aoogen time --dot --solid
aoogen t -m -d -s
aoogen t -m -s -d
aoogen t -m -s -l
aoogen t -l


@rem aoogen date -h (--human), -m (--minus), -d (--dot), -s (--solid)
@rem aoogen time -h (--human), -m (--minus), -d (--dot), -s (--solid)

@pause

@rem EOF
