#!/bin/bash

while true; do

    # Prompt the user for the name of the required file
    read -p "Please enter text file name: " filename

    # Check that the file exists and is a file
    if [[ -e $filename ]] && [[ -f $filename ]]; then
        break
    else
        echo "That's not a valid file"
    fi
done

# Loop over every line in the file, printing the line and how many characters it has
while read -r line || [[ -n "$line" ]]; do
    char_count=$(echo $line | wc -m)
    (( char_count-- ))
    echo "The string $line contains $char_count characters"
done < $filename

exit 0 