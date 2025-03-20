#!/bin/bash

if [[ $# -eq 1 ]] && [[ -f $1 ]]; then
    printf "%-10s | %-10s | %-30s | %-10s \n" "SURNAME" "FNAME" "EMAIL" "PHONE"
    while IFS=, read -r fname surname phone email || [ -n "$email" ]; do
        printf "%-10s | %-10s | %-30s | %-10s \n" "$surname" "$fname" "$email" "$phone"
    done < <(tail -n +2 "$1")
else
    echo -e "This script requires a .csv file name at execution, for example:\n  $0 file.csv\nPlease try again."
fi

exit 0