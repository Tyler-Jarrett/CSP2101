#!/bin/bash

protocols=()
GREEN='\033[32m'
NC='\033[0m'
rm -f temp.csv results.csv

while true; do
    read -p "Please enter name of log file (.csv): " file

    if [[ -f "$file" ]]; then
        awk '{ gsub(/ *, */, ","); print }' "$file" > temp.csv
        while IFS= read -r line || [ -n "$line" ]; do
            protocols+=("$line")
        done < <(awk -F',' 'NR>1 { print toupper($3) }' temp.csv | sort -u)

        if [[ ${#protocols[@]} -eq 0 ]]; then
            echo "No protocol data found in file. Exiting."
            exit 1
        else
            echo -e "Available protocols: ${GREEN}${protocols[@]}${NC}"
            while true; do
                read -p "Please enter one of the above protocols to search (in uppercase): " prot
                prot_upper=$(echo "$prot" | tr '[:lower:]' '[:upper:]')
                if [[ " ${protocols[*]} " =~ " ${prot_upper} " ]]; then
                    break
                else
                    echo "Invalid protocol. Please try again."
                fi
            done
            awk -F',' -v proto="$prot_upper" '
                toupper($3) == proto {
                    printf "%-10s %-10s %-10s\n", $3, $8, $9
                }' temp.csv | sort -k2,2nr > results.csv

            if [[ -s results.csv ]]; then
                echo "$(wc -l < results.csv) matches were found of which $(uniq results.csv | wc -l) are unique, these being:"
                uniq results.csv | sort -k3,3nr
            else
                echo "No matches found"
            fi

            break
        fi

    else
        echo "No such file in this directory. Please try again."
    fi
done

exit 0