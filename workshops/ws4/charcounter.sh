#!/bin/bash
read -p "Enter text file name: " filename
while IFS= read -r line; do
lines+=("$line")
done < "$filename"
i=0
until (( i == ${#lines[@]} )); do
char_count=0
j=1
while [[ -n "$(expr substr "${lines[i]}" $j 1)" ]]; do
((char_count++))
((j++))
done
echo "The string ${lines[i]} contains $char_count characters"
((i++))
done
exit 0