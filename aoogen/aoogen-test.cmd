@rem 
@rem 
@rem 

@set PATH=%PATH%;.\Win32\Debug
@set PATH=%PATH%;.\Win32\Release

aoogen none 

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


@rem aoogen date -h (--human), -m (--minus), -d (--dot), -s (--solid)
@rem aoogen time -h (--human), -m (--minus), -d (--dot), -s (--solid)
@rem aoogen datetime -h (--human), -m (--minus), -d (--dot), -s (--solid)

@pause

@rem EOF
