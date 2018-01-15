#!/usr/bin/env python
#!/usr/bin/python

# -*- coding: utf-8 -*-
#


import os
import sys
import getopt

from jmsort_processor import AoosortProcessor


def main(argv):
    # i = 0
    include_folders = []
    exclude_folders = []
    output_folder = ''
    mode = 'touch' # 'move' 'copy'
    try:
        opts, args = getopt.getopt(argv, "hi:o:x:n:m", ["include=", "output=", "exclude=", "mode="])
    except getopt.GetoptError:
        print('jmsort.py -i <include_folder> -o <output_folder> -x <exclude_folder>')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print('jmsort.py -i <include_folder> -o <output_folder> -x <exclude_folder>')
            sys.exit()
        elif opt in ("-i", "--include"):
            include_folder = arg.strip()
            include_folders.append(include_folder)
        elif opt in ("-o", "--output"):
            output_folder = arg.strip()
        elif opt in ("-x", "--exclude"):
            exclude_folder = arg.strip()
            exclude_folders.append(exclude_folder)
        elif opt in ("-m", "--mode"):
            mode = arg.strip()

    for include_folder in include_folders:
        print('Include folders:' + include_folder)

    for exclude_folder in exclude_folders:
        print('Exclude folder:' + exclude_folder)

    print('Output folder:' + output_folder)

    processor = AoosortProcessor(include_folders, exclude_folders, output_folder, mode)
    processor.process()


if __name__ == "__main__":
    main(sys.argv[1:])

