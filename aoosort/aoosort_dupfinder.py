#!/usr/bin/env python
# -*- coding: utf-8 -*-

# TODO: fix wrong exclude folder behavior with localized file names

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

    def list_folder(self, result, initial):
        if os.path.isdir(initial):
            if not initial in result:
                result.append(initial)
            subfolders = []
            for item in os.listdir(initial):
                f = os.path.join(initial, item)
                if os.path.isdir(f):
                    if "Just" in f:
                      print(f)
                      print(self.exclude_folders)
                      
                    if f in self.exclude_folders:
                        continue
                    # if f.decode("cp1251") in self.exclude_folders:
                    #    continue
                    subfolders.append(f)
                    result.append(f)
            for subfolder in subfolders:
                self.list_folder(result, subfolder)

    def prepare_folder_list(self):
        # print(self.exclude_folders)
        for include_folder in self.include_folders:
            self.list_folder(self.folder_list, include_folder)
        # for folder in self.folder_list:
        #     print(folder)

    def save_to_file(self, file_name, lines):
        file_encoding = 'utf-8'
        #if sys.platform.startswith('win'):
        #    file_encoding = 'cp1251'
        f = codecs.open(file_name, 'w+', encoding=file_encoding)
        try:
            for line in lines:
                f.write(line.decode("cp1251"))
                f.write("\n")
        finally:
            f.close()

    def process(self):
        debug(u"Prepare folder list...")
        self.prepare_folder_list()
        
        cmd_file_header = ""
        cmd_file_name = "mvdupe.txt"
        move_cmd = "//"
        line_comment = "//"
        cmd_file_footer = ""
        if sys.platform.startswith('linux'):  
            cmd_file_header = "#!/bin/bash"
            cmd_file_footer = "echo Complete... && read"
            cmd_file_name = "mvdupe.sh"
            line_comment = "# "
            move_cmd = 'mv "{}" [SPACEPAD] {} {} {}{}'
        if sys.platform.startswith('win'):
            cmd_file_name = "mvdupe.cmd"
            cmd_file_header = "@echo off"
            cmd_file_footer = "echo Complete... & pause"
            line_comment = "rem "
            move_cmd = 'move "{}" [SPACEPAD] {} {} {}{}'
        
        mv_cmd_list = []
        mv_cmd_list.append(cmd_file_header)
        
        debug(u"Processing...")
        for folder in self.folder_list:
            # debug(u"Processing '{}'".format(folder))
            photo_hash = {}
            for item in os.listdir(folder):
                f = os.path.join(folder, item)
                if os.path.isfile(f):            
                    photo = AoosortPhoto(f)
                    if photo.is_valid():
                        if not photo.datetime in photo_hash:
                            photo_hash[photo.datetime] = []
                        photo_hash[photo.datetime].append(photo)
                        
            if 1 > len(photo_hash):
                # debug(u"No files found in '{}'".format(folder))
                continue
                
            for t in photo_hash:
                if 1 < len(photo_hash[t]):
                  folder_line = line_comment + ":   " + folder
                  mv_cmd_list.append(folder_line)
                  break

            max_file_path_len = 0
            for t in photo_hash:
                if 1 < len(photo_hash[t]):
                    for photo in photo_hash[t]:
                        if max_file_path_len < len(photo.file_path):
                            max_file_path_len = len(photo.file_path)
                  
            for t in photo_hash:
                if 1 < len(photo_hash[t]):
                    # debug(u"Dupes found for '{}'".format(t))
                    i = 0
                    max_size = 0
                        
                    for photo in sorted(photo_hash[t], key=lambda photo_item: (photo_item.size, len(photo_item.file_name)), reverse=True):
                        # debug(u"Item {}: {} ({})".format(i, photo.file_name, photo.size))
                        cmd = ''
                        sign = ' '
                        is_largest = 0 == i  # (-; cus of reverse sorted by size
                        is_manual = \
                            ("crop" in photo.file_name.lower()) or \
                            ("gimp" in photo.file_name.lower()) or \
                            ("pano" in photo.file_name.lower()) or \
                            ("converted" in photo.file_name.lower()) or \
                            ("photivo" in photo.file_name.lower()) or \
                            ("ps" in photo.file_name.lower())
                        is_serial = \
                            ("k5a." in photo.file_name.lower()) or \
                            ("k5b." in photo.file_name.lower()) or \
                            ("k5c." in photo.file_name.lower()) or \
                            ("k5d." in photo.file_name.lower()) 
                        if is_largest or is_manual or is_serial:
                            max_size = photo.size
                            cmd = line_comment
                        else:
                            cmd = " ".rjust(len(line_comment))
                            if photo.size == max_size:
                                sign = '='
                        cmd += move_cmd.format(photo.file_path, self.backup_folder, line_comment, sign, photo.size)
                        spacepad = " ".ljust(max_file_path_len - len(photo.file_path))
                        cmd = cmd.replace("[SPACEPAD]", spacepad)
                        mv_cmd_list.append(cmd)
                        i += 1

        mv_cmd_list.append(cmd_file_footer)
        mv_cmd_list.append(line_comment + "EOF")
                        
        cmd_file = os.path.join(self.backup_folder, cmd_file_name) 
        self.save_to_file(cmd_file, mv_cmd_list)
                
        debug(u"Complete...")
                
                
            
            
                    
                    
        
