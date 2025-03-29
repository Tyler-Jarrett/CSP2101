#!/bin/bash

# Initialise line counter
linecount=0

# Loop over every line in the file
while read -r line || [ -n "$line" ]; do
	(( linecount++ ))
	# Process substitution, using wc to count the words in the line
	wordcount=$(echo $line | wc -w)
	# Print out the current line number, and how many words it contains
	echo "Line $linecount contains $wordcount words"
	# Redirect the file into the input of the loop
done < sentences.txt

exit 0