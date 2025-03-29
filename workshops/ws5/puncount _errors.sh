#!/bin/bash

# The purpose of this script is to count the number of lines in an input text file that START0 with a lowercase letter AND END in a colon.

read -p "Enter file name: " input_file

if [[ ! -f "$input_file" ]]; then
  echo "File '$input_file' not found."
  exit 1
fi

match_count=$(grep -v '[a-z].*:' "$input_file" | wc -l)

echo "Number of matching lines: $match_count"

exit 0