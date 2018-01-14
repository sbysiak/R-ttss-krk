#!/bin/bash

#url="http://www.ttss.krakow.pl/#?stop=77&mode=departure"
url="https://mpk.jacekk.net/#!pl77"
./save_page_as $url -d out --save-wait-time 3 --load-wait-time 3

grep "Bronowice" out.html > torm.txt
export Nlines=`wc -l torm.txt | cut -d " " -f 1`
if (test $Nlines -eq 0); then
    echo "ERROR: webpage saving failed !"
else
    echo "INFO: webpage saving succeeded"
fi
rm torm.txt
rm out_files -r
#rm tmp/* -r
