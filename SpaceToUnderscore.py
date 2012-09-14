#!/usr/bin/python
#
# List of all the files, total count of files and folders & Total size  of files.
import os
import sys
import re

fileCount = 0

if len(sys.argv) < 2:
    print >>sys.stderr, "Usage:", sys.argv[0], "FILENAME"
    sys.exit(1)

rootdir = sys.argv[1]

for root, subFolders, files in os.walk(rootdir):
   for file in files:
      oldfile = os.path.join(root,file)
      if(re.search('\s+',file) and os.path.isfile(oldfile)):
         newfile = os.path.join(root,re.sub('\s+','_',file))
         print "OLD:", oldfile
         print "NEW:", newfile
         os.rename(oldfile,newfile)
         fileCount = fileCount + 1;

print("Total Files Fixed ", fileCount)

