#!/usr/bin/env python
#!/usr/bin/python

# -*- coding: utf-8 -*-
#


import os
import sys
import getopt

from aoosort_dupfinder import AoosortDupFinder


def main(argv):
    # i = 0
    include_folders = []
    exclude_folders = []
    backup_folder = ''
    mode = 'touch' # 'move' 'copy'
    try:
        opts, args = getopt.getopt(argv, "hi:b:x:n:m", ["include=", "backup=", "exclude=", "mode="])
    except getopt.GetoptError:
        print('dupefind.py -i <include_folder> -o <backup_folder> -x <exclude_folder>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('dupefind.py -i <include_folder> -o <backup_folder> -x <exclude_folder>')
            sys.exit()
        elif opt in ("-i", "--include"):
            include_folder = arg.strip()
            include_folders.append(include_folder)
        elif opt in ("-b", "--backup"):
            backup_folder = arg.strip()
            if not os.path.isdir(backup_folder):
                print("Backup folder '{}' doesn't exists, exiting...".format(backup_folder))
                exit(2)
        elif opt in ("-x", "--exclude"):
            exclude_folder = arg.strip()
            exclude_folders.append(exclude_folder)
        elif opt in ("-m", "--mode"):
            mode = arg.strip()

    for include_folder in include_folders:
        print('Include folders:' + include_folder)

    for exclude_folder in exclude_folders:
        print('Exclude folder:' + exclude_folder)

    print('Backup folder:' + backup_folder)

    dup_finder = AoosortDupFinder(mode, include_folders, exclude_folders, backup_folder)
    dup_finder.process()


if __name__ == "__main__":
    main(sys.argv[1:])

