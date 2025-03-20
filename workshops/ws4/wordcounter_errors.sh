#!/bin/bash

lcnt=1

while read -r line; do
	(( lcnt++ ))
	wcnt=`echo $line | wc -c`
	echo "Line $lcnt contains $wcnt words"
done < sentences.txt

exit 0