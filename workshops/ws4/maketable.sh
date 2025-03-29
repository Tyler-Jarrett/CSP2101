#!/bin/bash

# Check if there is one file passed in, ideally a csv
if [[ $# -eq 1 ]] && [[ -f $1 ]]; then
    # Print format string to show the headers of the table
    printf "%-10s | %-10s | %-30s | %-10s \n" "SURNAME" "FNAME" "EMAIL" "PHONE"
    # Loop over every line except the first one, storing each field as a variable
    while IFS=, read -r fname surname phone email || [ -n "$email" ]; do
        # Print format string, formatting the information as a table
        printf "%-10s | %-10s | %-30s | %-10s \n" "$surname" "$fname" "$email" "$phone"
        # Command substitution, redirected into the input of the loop, grab all lines but the first
    done < <(tail -n +2 "$1")
else
    # Print error, state that this script requires a csv at execution
    echo -e "This script requires a .csv file name at execution, for example:\n  $0 file.csv\nPlease try again."
fi

exit 0