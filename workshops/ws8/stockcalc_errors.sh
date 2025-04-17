#!/bin/bash

# DECLARE REQUIRED VARIABLES
output_format=""
unique_brands=()
RED='\033[0;31m' # to colour error messages
GREEN='\033[0;32m' # to highlight key output values
BLUE='\033[0;34m' # for output headers
NC='\033[0m' # switches off the application of a colour to oputput

calculate_total() {
    awk -v brand="$2" '
        BEGIN { total = 0 }
        NR > 1 && tolower($2) == tolower(brand) {
            total += $7
        }
        END { print total }
    ' "$1"
}

# Check if brand and output_format were provided
if [[ ! $# -eq 2 ]]; then
    echo -e "You need to provide a valid flag (-d or -i) and a .csv file name\n./stockcalc.sh -d source.csv"
    exit 1
else
    # Parse command-line options
    while getopts ":d:i:" opt; do
        case $opt in
            d)
                csvfile="$OPTARG"
                output_format="decimal"
                ;;
            i)
                csvfile="$OPTARG"
                output_format="integer"
                ;;
            *)
                echo "Invalid option provided - must be -d or -i"
                exit 1
                ;;
        esac
    done
    
    while IFS= read -r line || [ -n "$line" ]; do
        unique_brands+=("$line")
    done < <(cut -d',' -f2 source.csv | sort -u)
    echo "OPTIONS:- ${BLUE}${unique_brands[@]}${NC}"
    read -p "Enter a brand name from the options above: " brand
    total=$(calculate_total "$csvfile" "$brand")
fi

# Format the total based on the flag
if [[ "$output_format" == "decimal" ]]; then
    printf "Total value of %s stock: \$%'.2f\n" "$brand" "$total"
elif [[ "$output_format" == "integer" ]]; then
    total_rounded=$(printf "%.0f" "$total")
    printf "Total value of %s stock: \$%'d\n" "$brand" "$total_rounded"
fi

exit 0