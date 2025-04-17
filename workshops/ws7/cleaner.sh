#!/bin/bash

if [ -z "$1" ]; then
    echo "You need to provide the name of an input file. Please try again."
    exit 1
fi

input_file="$1"
output_file="${input_file%.csv}_cleaned.csv"

header=$(head -n 1 "$input_file")
echo "$header" > "$output_file"

tail -n +2 "$input_file" | sed '/^Date,Time,IP,Method,URL,Status$/d' | sed '/,200$/!d' >> "$output_file"

sed -E -i 's/^([A-Za-z]+) ([0-9]{1,2}), ([0-9]{4})/\3-03-\2/; s|([0-9]{2})-([0-9]{2})-([0-9]{4})|\3-03-\1|; s|([0-9]{4})/([0-9]{2})/([0-9]{2})|\1-03-\3|' "$output_file"

sed -E -i 's/([0-9]+\.[0-9]+\.[0-9]+)\.[0-9]+/\1.xxx/' "$output_file"

echo "Data cleaned and saved to $output_file"

exit 0