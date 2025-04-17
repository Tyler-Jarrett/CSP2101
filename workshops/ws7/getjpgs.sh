#!/bin/bash

curl -s "https://unsplash.com" > temp.txt
cat temp.txt | grep -Eo '(http|https)://[^"]+' | grep "\.jpg" | sed 's%\?.*$%%g' | sed 's%.*\/%%g' > result.txt


exit 0