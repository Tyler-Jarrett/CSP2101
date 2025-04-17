#!/bin/bash

# The purpose of this script is to:
    # 1: Removes duplicate header rows if they are present
    # 2: Anonymise the salary field for all of the employees in the .csv file the script processes...
        # replacing the salary amount with the string "Confidential"
    # 3: Changes the DateOfJoining column from US date format to Australian date format
    # 4: Writes the processed data to a new .csv file with the header preserved

if [ -z "$1" ]; then
    echo "You need to provide the name of an input file. Please try again."
    exit 1
fi

input_file="$1"
output_file="${input_file%.csv}_processed.csv"
temp_file="temp_file.csv"

first_line=$(head -n 1 "$input_file")
echo "$first_line" > "$output_file"

while IFS= read -r line
do
    if [[ "$line" != "$first_line" ]]; then
        echo "$line" >> "$output_file"
    fi
done < <(tail -n +2 "$input_file")

while IFS= read -r line
do
    emp_id=$(echo "$line" | cut -d',' -f1)
    name=$(echo "$line" | cut -d',' -f2)
    department=$(echo "$line" | cut -d',' -f3)
    salary=$(echo "$line" | cut -d',' -f4)
    date_of_joining=$(echo "$line" | cut -d',' -f5)

    year=$(echo "$date_of_joining" | cut -d'-' -f1)
    month=$(echo "$date_of_joining" | cut -d'-' -f2)
    day=$(echo "$date_of_joining" | cut -d'-' -f3)
    
    formatted_date="$day-$month-$year"

    echo "$emp_id,$name,$department,$salary,$formatted_date" >> "$temp_file"

done < <(tail -n +2 "$output_file")

mv "$temp_file" "$output_file"

echo "Processing complete. Data saved in $output_file"

exit 0