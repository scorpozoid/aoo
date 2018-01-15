#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import os
import sys
import datetime


def warning(msg):
    print(msg.encode(sys.stdout.encoding, errors='replace'))


class JmsortPhoto:
    def __init__(self, file_path):
        self.file_path = file_path
        self.file_name = os.path.basename(file_path)
        self.yyyy = None
        self.mm = None
        self.dd = None
        self.hh = None
        self.nn = None
        self.ss = None
        self.ms = None
        self.timestamp = None
        self.datetime = None
        self.size = 0

        # re_flags = re.IGNORECASE | re.UNICODE
        re_flags = re.IGNORECASE
        
        m7 = re.match("(\d\d\d\d)[\.\-\_](\d\d)[\.\-\_](\d\d)[\.\-\_](\d\d)[\.\-\_](\d\d)[\.\-\_](\d\d)[\.\-\_](\d\d\d)", self.file_name, re_flags)
        if m7:
            self.yyyy = m7.group(1)
            self.mm = m7.group(2)
            self.dd = m7.group(3)
            self.hh = m7.group(4)
            self.nn = m7.group(5)
            self.ss = m7.group(6)
            self.ms = m7.group(7)
        else:
            m61 = re.match("(\d\d\d\d)[\.\-\_](\d\d)[\.\-\_](\d\d)[\.\-\_](\d\d)[\.\-\_](\d\d)[\.\-\_](\d\d)", self.file_name, re_flags)
            if m61:
                self.yyyy = m61.group(1)
                self.mm = m61.group(2)
                self.dd = m61.group(3)
                self.hh = m61.group(4)
                self.nn = m61.group(5)
                self.ss = m61.group(6)
                self.ms = '000'
            else:
                m62 = re.match("(\d\d\d\d)(\d\d)(\d\d)[\.\-\_](\d\d)[\.\-\_](\d\d)[\.\-\_](\d\d)", self.file_name, re_flags)
                if m62:
                    self.yyyy = m62.group(1)
                    self.mm = m62.group(2)
                    self.dd = m62.group(3)
                    self.hh = m62.group(4)
                    self.nn = m62.group(5)
                    self.ss = m62.group(6)
                    self.ms = '000'
                else:
                    m63 = re.match("Screenshot_(\d\d\d\d)(\d\d)(\d\d)[\.\-\_](\d\d)(\d\d)(\d\d)", self.file_name, re_flags)
                    if m63:
                        self.yyyy = m63.group(1)
                        self.mm = m63.group(2)
                        self.dd = m63.group(3)
                        self.hh = m63.group(4)
                        self.nn = m63.group(5)
                        self.ss = m63.group(6)
                        self.ms = '000'
                    else:
                        m64 = re.match("(\d\d\d\d)(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)", self.file_name, re_flags)
                        if m64:
                            self.yyyy = m64.group(1)
                            self.mm = m64.group(2)
                            self.dd = m64.group(3)
                            self.hh = m64.group(4)
                            self.nn = m64.group(5)
                            self.ss = m64.group(6)
                            self.ms = '000'

        if self.yyyy is not None:
            try:
                self.timestamp = datetime.datetime(int(self.yyyy), int(self.mm), int(self.dd), int(self.hh), int(self.nn), int(self.ss), int(self.ms) * 1000)
                self.datetime = datetime.datetime(int(self.yyyy), int(self.mm), int(self.dd), int(self.hh), int(self.nn), int(self.ss))
                self.size = os.path.getsize(self.file_path)
            except:
                self.datetime = None
                warning(u"Error get photo date/time".format(self.file_path))


    def is_valid(self):
        return self.datetime is not None
