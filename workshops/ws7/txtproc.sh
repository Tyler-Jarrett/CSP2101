#!/bin/bash

sed -e 's$<b>$<strong>$g'   \
    -e 's$</b>$</strong>$g' \
    -e 's$<i>$<em>$g'       \
    -e 's$</i>$</em>$g'     \
    -e 's$kernal$kernel$g'  \
    -e 's$http$https$g'     \
    -e 's$<p>$\n<p style="standardtext">$g'      \
    inputfile.html > inputfile_u.txt

exit 0