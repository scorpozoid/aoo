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


class AoosortProcessor:
    def __init__(self, include_folders, exclude_folders, output_folder, mode):
        self.include_folders = include_folders
        self.exclude_folders = exclude_folders
        self.output_folder = output_folder
        self.mode = mode.lower()
        self.file_list = []
        self.pre_datetime = None
        self.pre_dir_date = None
        self.input_file_count = 0
        self.input_valid_photo_count = 0
        self.processed_count = 0
        self.output_photo_count = 0


    def __str__(self):
        return "AoosortProcessor"
        # return "{} -> {}".format(self.include_folders.strip(), self.output_folder.strip())


    def decode_file_name(self, file_name):
        # #return file_name.decode("cp1251")
        # # Linux 	'linux'
        # # Windows 	'win32'
        # # Windows/Cygwin 	'cygwin'
        # # Mac OS X 	'darwin'
        # if sys.platform.startswith('win'):
        #     return file_name.decode("cp1251")
        # else:
        #     return file_name
        if isinstance(file_name, str):
            return file_name.decode("cp1251")
        elif isinstance(file_name, unicode):
            return file_name
        else:
            print ""


    def prepare_file_list(self):
        # from os.path import isfile, join
        # fotopath = os.getcwd()
        # if 1 < len(sys.argv):
        #     fotopath = sys.argv[1]
        # fotolist = [ f for f in listdir(fotopath) if isfile(join(fotopath,f)) ]
        for include_folder in self.include_folders:
            for root, directories, filenames in os.walk(include_folder):
                for filename in filenames:
                    root_name = self.decode_file_name(root)
                    if os.path.isdir(root_name):
                        if root_name in self.exclude_folders:
                            debug(u"Folder excluded - {}".format(root_name))
                            continue
                    file_name = self.decode_file_name(filename)
                    file_path = os.path.join(root_name, file_name)
                    if os.path.exists(file_path):
                        self.file_list.append(file_path)


    def store_invalid_file_name_list(self, file_name_list):
        file_encoding = 'utf-8'
        if sys.platform.startswith('win'):
            file_encoding = 'cp1251'
        file_name = os.path.join(self.output_folder, "invalid.lst")
        print(file_name)
        f = codecs.open(file_name, 'w+', encoding=file_encoding)
        try:
            f.write(u'# {}\n'.format(file_encoding))
            for file_name in file_name_list[:]:
                f.write(u"{}\n".format(file_name))
            f.write(u'# EOF\n')
        finally:
            f.close()


    def process_photo_file(self, source_file_path, target_file_path):
        debug(u"Target: {}".format(target_file_path))

        if "touch" == self.mode:

            if os.path.exists(target_file_path):
                warning(u"Skip '{}' - already exists".format(target_file_path))
            else:
                self.touch_file(target_file_path)
                self.output_photo_count += 1

        elif ("copy" == self.mode) or ("move" == self.mode):

            if os.path.exists(target_file_path):
                target_size = os.path.getsize(target_file_path)
                source_size = os.path.getsize(source_file_path)
                if source_size <> target_size:
                    head, tail = os.path.split(target_file_path)
                    base, ext = os.path.splitext(tail)
                    new_target_file_path = os.path.join(head, base + '-0' + ext.lower())
                    warning(u"Rename '{}' - already exists, size difference ({}, {}, '{}') ".format(target_file_path, source_size, target_size, new_target_file_path))
                    self.process_photo_file(source_file_path, new_target_file_path)
                else:
                    warning(u"Skip '{}' - already exists with same size ({})".format(target_file_path, source_size))
            else:
                self.output_photo_count += 1
                if "copy" == self.mode:
                    shutil.copyfile(source_file_path, target_file_path);
                elif "move" == self.mode:
                    shutil.move(source_file_path, target_file_path)
        else:
            print(u"{} -> {}".format(source_file_path, target_file_path))


    def get_month_caption(self, photo_mm):
        months = {
            "01": u" Январь",
            "02": u" Февраль",
            "03": u" Март",
            "04": u" Апрель",
            "05": u" Май",
            "06": u" Июнь",
            "07": u" Июль",
            "08": u" Август",
            "09": u" Сентябрь",
            "10": u" Октябрь",
            "11": u" Ноябрь",
            "12": u" Декабрь"
        }
        try:
            return months[photo_mm]
        except KeyError as e:
            return u""


    def get_date_caption(self, photo):
        if 12 == int(photo.mm) and 17 == int(photo.dd):
            return u" Тамара (ДР)"
        if 5 == int(photo.mm) and 8 == int(photo.dd):
            return u" Борис (ДР)"
        return u""
        

    def is_continuous(self, photo):
        if 6 > int(photo.hh):
            if self.pre_datetime is not None:
                timespan = abs(photo.datetime - self.pre_datetime)
                minspan = timespan.total_seconds() / 60
                if 120 > minspan:
                    debug(u"[!] Party goes on! {0} -> {1} ({2}min)".format(self.pre_dir_date, photo.datetime, minspan))
                    dir_date = self.pre_dir_date
        
        
    def process_photo(self, photo):

        dir_year = os.path.join(self.output_folder, photo.yyyy)
        if not os.path.exists(dir_year):
            os.makedirs(dir_year)

        month_caption = self.get_month_caption(photo.mm)
        dir_month = os.path.join(dir_year, u"{}.{}.00{}".format(photo.yyyy, photo.mm, month_caption)) 
        if not os.path.exists(dir_month):
            os.makedirs(dir_month)

        date_caption = self.get_date_caption(photo)
        dir_date = os.path.join(dir_month, u"{}.{}.{}{}".format(photo.yyyy, photo.mm, photo.dd, date_caption))
        if self.is_continuous(photo):
            dir_date = self.pre_dir_date                    
        if not os.path.exists(dir_date):
            os.makedirs(dir_date)

        # base, ext = os.path.splitext(photo.file_name)
        # target_file_path = os.path.join(dir_date, "{}{}".format(base, ext.lower()))
        
        target_file_path = os.path.join(dir_date, photo.file_name)
        self.process_photo_file(photo.file_path, target_file_path)

        self.pre_datetime = photo.datetime
        self.pre_dir_date = dir_date
            

    def touch_file(self, file_name):
        file_encoding = 'cp1251'  # 'utf-8' 'cp1251'
        f = codecs.open(file_name, 'w', encoding=file_encoding)
        try:
            f.write(u'{}\n'.format(file_name))
        finally:
            f.close()


    def process(self):
        self.input_file_count = 0
        self.input_valid_photo_count = 0
        self.processed_count = 0
        self.output_photo_count = 0

        self.prepare_file_list()
        photo_list = []
        invalid_file_name_list = []
        for file_name in self.file_list:
            self.input_file_count += 1
            photo = AoosortPhoto(file_name)
            if photo.is_valid():
                self.input_valid_photo_count += 1
                photo_list.append(photo)
                #debug("Photo added: {} {}".format(photo.file_name, photo.size))
            else:
                invalid_file_name_list.append(file_name)
                #warning(u"Invalid file: {}".format(file_name.decode("cp1251")))
                print(file_name)
                warning(u"Invalid file: {}".format(file_name))

        debug("Input count: {}".format(self.input_file_count))
        debug("Valid photo count: {}".format(self.input_valid_photo_count))

        if 0 < len(invalid_file_name_list):
            warning(u"Invalid file(s) count: {}".format(len(invalid_file_name_list)))
            self.store_invalid_file_name_list(invalid_file_name_list)

        for photo in sorted(photo_list, key=lambda photo_item: photo_item.timestamp, reverse=True):
            # debug("{} ({} {}) - {}".format(photo.file_name, photo.timestamp, photo.ms, photo.file_path))
            self.processed_count += 1
            self.process_photo(photo)
            if 0 == self.processed_count % 20:
                debug(u"Processing ({}): {}".format(self.processed_count, photo.file_path))

        debug("Input count: {}".format(self.input_file_count))
        debug("Invalid photo count: {}".format(len(invalid_file_name_list)))
        debug("Valid photo count: {}".format(self.input_valid_photo_count))
        debug("Processed count: {}".format(self.processed_count))
        debug("Output count: {}".format(self.output_photo_count))

# EOF
