#!/usr/bin/env python
#

def main():
  import time
  import os
  import sys, getopt
  import re
  import time
  import shutil
  from datetime import date
  from datetime import timedelta
  from datetime import datetime
  from os import listdir
  from os import sys
  from os.path import isfile, join

  fotopath = os.getcwd()
  if 1 < len(sys.argv):
    fotopath = sys.argv[1]

  fotolist = [ f for f in listdir(fotopath) if isfile(join(fotopath,f)) ]

  predate = datetime(1000, 1, 1)
  curdate = datetime(1000, 1, 1)
  prepath = ""
  curpath = ""

  for fotoname in sorted(fotolist):
    print "[w] Photo '{0}'".format(fotoname)
    m = re.match("(\d\d\d\d)[\.\-\_](\d\d)[\.\-\_](\d\d)[\.\-\_](\d\d)[\.\-\_](\d\d)[\.\-\_](\d\d)", fotoname, re.IGNORECASE | re.UNICODE)
    if m:
      yy = int(m.group(1))
      mm = int(m.group(2))
      dd = int(m.group(3))
      hh = int(m.group(4))
      nn = int(m.group(5))
      ss = int(m.group(6))
      curdate = datetime(yy, mm, dd, hh, nn, ss)

      yearpath = os.path.join(fotopath, "{0:04d}".format(yy))
      curpath = os.path.join(yearpath, "{0:04d}-{1:02d}-{2:02d}".format(yy, mm, dd))

      if not os.path.exists(curpath):
        print ">> {0}".format(curpath)
        os.makedirs(curpath)

      if predate and prepath:
        if curdate.date() > predate.date():
          # print "[w] Date shift '{0}' -> '{1}'".format(predate.date(), curdate.date())
          timespan = abs(curdate - predate)
          minspan = timespan.total_seconds() / 60
          if 120 > minspan:
            #print "[!] Party goes on! {0} -> {1} ({2}min), use previous folder {3}".format(predate, curdate, minspan, prepath)
            print "[!] Party goes on! {0} -> {1} ({2}min)".format(predate, curdate, minspan)
            curpath = prepath

      #print("mv {0} to {1}".format(fotoname, curpath))
      fotoname = os.path.join(fotopath, fotoname)
      shutil.move(fotoname, curpath)

      predate = curdate
      prepath = curpath

if __name__ == "__main__":
  main()

