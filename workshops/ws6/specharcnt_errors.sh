#!/bin/bash

count_special_chars() {
    local input_str="$1"
    local special_chars=$(echo "$input_str" | grep -o '[^a-z0-9]' | tr -d '\n')
    local count=${#special_chars}
    echo "$special_chars" "$count"
}

file="$1"

if [ ! -f "$file" ]; then
    echo "File does not exist."
    exit 1
else
    printf "%-20s %-10s %-10s \n" "STRING" "COUNT" "MATCHES"
    while read line || [ -n "$line" ]; do
        result=$(count_special_chars "$line")
        specials=$(echo "$result" | cut -d' ' -f1)
        num_specials=$(echo "$result" | cut -d' ' -f2)
        printf "%-20s %-10s %-10s \n" "$line" "$num_specials" "$specials"
    done < "$file"
fi

exit 0