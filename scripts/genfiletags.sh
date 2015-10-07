#!/bin/sh
# generate tag file for vim lookupfile plugin
# execute under your root directory of project
echo -e "!_TAG_FILE_SORTED\t2\t/2=foldcase/" > .filetags
find . -not -regex '.*\.\(png\|gif\|o\)' -type f -printf "%f\t%p\t1\n" | \
     sort -f >> .filetags
