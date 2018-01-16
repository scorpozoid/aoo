#!/usr/bin/env python
# -*- coding: utf-8 -*-

import codecs
import sys
import os
import shutil

from aoosort_photo import AoosortPhoto


def debug(msg):
    print(msg.encode(sys.stdout.encoding, errors='replace'))


def warning(msg):
    print(msg.encode(sys.stdout.encoding, errors='replace'))


class AoosortDupFinder:
    def __init__(self, mode, include_folders, exclude_folders, backup_folder):
        self.include_folders = include_folders
        self.exclude_folders = exclude_folders
        self.backup_folder = backup_folder
        self.mode = mode.lower()
        self.folder_list = []
        #self.input_file_count = 0
        #self.dupe_count = 0

    def decode_file_name(self, file_name):
        # #return file_name.decode("cp1251")
        # if sys.platform.startswith('win'):  # 'linux' 'win32' 'cygwin' 'darwin'
        #     return file_name.decode("cp1251")
        # else:
        #     return file_name
        if isinstance(file_name, str):
            return file_name.decode("cp1251")
        elif isinstance(file_name, unicode):
            return file_name
        else:
            print ""

    def list_folder(self, result, initial):
        if os.path.isdir(initial):
            if not initial in result:
                result.append(initial)
            subfolders = []
            for item in os.listdir(initial):
                f = os.path.join(initial, self.decode_file_name(item))
                if os.path.isdir(f):
                    if f in self.exclude_folders:
                        debug(u"Folder excluded - {}".format(f))
                    subfolders.append(f)
                    result.append(f)
            for subfolder in subfolders:
                self.list_folder(result, subfolder)

    def prepare_folder_list(self):
        debug(u"Prepare folder list...")
        for include_folder in self.include_folders:
            self.list_folder(self.folder_list, include_folder)

    def save_to_cmd_file(self, file_name, cmd_list):
        file_encoding = 'utf-8'
        if sys.platform.startswith('win'):
            file_encoding = 'cp1251'
        f = codecs.open(file_name, 'w+', encoding=file_encoding)
        try:
            # f.write(u'# {}\n'.format(file_encoding))
            for cmd in cmd_list:
                f.write(u"{}\n".format(cmd))
            f.write(u'# EOF\n')
        finally:
            f.close()

    def process(self):
        self.prepare_folder_list()
        mv_cmd_list = []
        mv_cmd_list.append("#!/bin/bash")
        for folder in self.folder_list:
            debug(u"Processing '{}'".format(folder))
            mv_cmd_list.append(u"#\n# {}".format(folder))
            photo_hash = {}
            for item in os.listdir(folder):
                f = os.path.join(folder, self.decode_file_name(item))
                if os.path.isfile(f):            
                    photo = AoosortPhoto(f)
                    if photo.is_valid():
                        if not photo.datetime in photo_hash:
                            photo_hash[photo.datetime] = []
                        photo_hash[photo.datetime].append(photo)
                        
            if 1 > len(photo_hash):
                debug(u"No dupes found in '{}'".format(folder))
                continue
                
            for t in photo_hash:
                if 1 < len(photo_hash[t]):
                    debug(u"Dupes found for '{}'".format(t))
                    i = 0
                    max_size = 0
                    for photo in sorted(photo_hash[t], key=lambda photo_item: (photo_item.size, len(photo_item.file_name)), reverse=True):
                        debug(u"Item {}: {} ({})".format(i, photo.file_name, photo.size))
                        cmd = ''
                        sign = ''
                        if 0 == i:
                            max_size = photo.size
                            cmd = '# '
                        if photo.size == max_size:
                            sign = '='
                        cmd += "mv {} \t\t {} # {}{}".format(photo.file_path, self.backup_folder, sign, photo.size)
                        mv_cmd_list.append(cmd)
                        i += 1
                        
        cmd_file = os.path.join(self.backup_folder, "mvdupe.sh") 
        self.save_to_cmd_file(cmd_file, mv_cmd_list)
                
                
                
            
            
                    
                    
        
