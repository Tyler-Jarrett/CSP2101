#!/bin/bash
# Student name: Tyler Schwehr
# Student number: 10325932

# Declare the constants for the colour change, used the checkstrings.sh from workshop 5 to create these
BLUE='\033[94m'
NC='\033[0m'

# Check to see if 3 arguments have been provided, give an error if they haven't
if [[ ! $# -eq 3 ]]; then
    echo "You do not have the correct number of arguments, your arguments should be RAM amount, storage amount, and the csv file"
    exit 1

# Check to see that the file provided exists, is a normal file, and ends in csv, otherwise give an error
elif [[ ! -e $3 ]] || [[ ! -f $3 ]] || [[ ! $3 =~ csv$ ]]; then
    echo "That is not a valid file, please ensure that you have typed the name correctly and it is a csv"
    exit 1

# Check that the RAM value is only consisting of numeric values, otherwise give an error
elif [[ ! $1 =~ ^[0-9]+$ ]]; then
    echo "The RAM value is incorrect, please make sure that it only includes numeric values"
    exit 1

# Check that the storage value is only consisting of numeric values, otherwise give an error
elif [[ ! $2 =~ ^[0-9]+$ ]]; then
    echo "The storage value is incorrect, please make sure that it only includes numeric values"
    exit 1

fi


# grep the file and redirect the results into a temporary file
cat $3 | grep "$1,$2" | sort > results.txt

# Read the results and count the number of lines
result_count=$(cat results.txt | wc -l)
# Print out how many total devices were found
echo "$result_count devices were found with $1GB RAM and $2GB Storage from:"


# Declare an array to store each unique brand name
declare -a brand_list

# Loop over every unique brand and add them to the array
while read -r brand || [ -n "$brand" ]; do

    brand_list+=($brand)

# Process substitution - retrieve the second field (brand) and pipe it into the uniq command
done  < <(cut -d , -f 2 results.txt | uniq)

# Loop over every brand in the array
for brand in ${brand_list[@]}; do

    # Get the count of lines that match the brand name
    count=$(grep -c "$brand" results.txt)
    # Print the brand and the count of how many times it appears in the list
    printf "%-10s (%s)\n" "$brand" "$count"

done


# Print the table headers in the blue colour, reset colour afterwards
printf "${BLUE}%-15s | %-15s | %-15s | %-15s ${NC}\n" "BRAND" "MODEL" "COLOUR" "PRICE"

# Loop over the entire list extracting each field
# The -n test is to capture the last line if it doesn't have a new line character
while IFS=, read -r name brand model ram storage colour price || [ -n "$price" ]; do

    # Print the relevant fields into a table format
    printf "%-15s | %-15s | %-15s | $%-15s \n" "$brand" "$model" "$colour" "$price"

done < results.txt

# Remove our temporary file
rm results.txt

exit 0