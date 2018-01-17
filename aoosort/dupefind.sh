#!/bin/sh

export USBHDD=/media/$USER/SBP2T

echo $USER
echo $USBHDD

python dupefind.py \
  --mode=notice \
  -i "$USBHDD/alb/photo/2012/2012.11.00 Ноябрь" \
  -i "$USBHDD/alb/photo/2012/2012.12.00 Декабрь" \
  -i "$USBHDD/alb/photo/2012/2012.09.00 Сентябрь" \
  -i "$USBHDD/alb/photo/2012/2012.10.00 Октябрь" \
  -i "$USBHDD/alb/photo/2013" \
  \
  -x "$USBHDD/alb/photo/2013/2013.06.00 Июнь/2013.06.30 Wedding" \
  \
  -b "$USBHDD/alb/temp/2018.01.17-2012-2017-dupes"

# EOF

#  -i "$USBHDD/alb/photo/2014" \
#  -i "$USBHDD/alb/photo/2015" \
#  -i "$USBHDD/alb/photo/2016" \
#  -i "$USBHDD/alb/photo/2017" \
