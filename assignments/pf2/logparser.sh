#!/bin/bash
# Student name: Tyler Schwehr
# Student number: 10325932

# Convert arguments to name variables
source_file=$1
destination_file=$2

# Validation checks that enough arguments have been provided, the source file exists, and both the source and destination files are .csv
# I considered doing a check to make sure that the destination did not exist, but concluded that it's the user's choice whether or not to overwrite a file
if [[ ! $# -eq 2 ]] || [[ ! -f $source_file ]] || [[ ! $source_file =~ .csv$ ]] || [[ ! $destination_file =~ .csv$ ]]; then
    # Print error message
    echo "One or more arguments are either missing or invalid, this command should be run with the source csv file and destination csv file"
    # Exit with an error code
    exit 1
fi

# Print the processing statement
echo "Processing..."

    # Convert the date to the correct format
    # Convert spaces to commas, it will make it easier for awk later
    # Output to a temporary file for easy management
sed -e 's#\[\([0-9]*\)/\([a-zA-Z]*\)/\([0-9]*\):[0-9]*:[0-9]*:[0-9]*#\1/\2/\3#g' \
    -e 's# #,#g' $source_file > temp_file.csv

    # Using awk to process the rest of the changes, starting with updating the heading line
    # Then I use the substring command to exclude the first / from the fourth column
    # I use the substitution command to remove the url arguments
    # Finally I use printf to output everything to the destination file
awk 'BEGIN {
        FS=","; 
        print "IP,Date,Method,URL,Protocol,Status";
        }
    NR>1 {
        $4 = substr($4, 2);
        sub(/?.*$/, "", $4);
        printf "%s,%s,%s,%s,%s,%s\n", $1,$2,$3,$4,$5,$6;        
        }' temp_file.csv > $destination_file

# Get the total number of lines, excluding the heading
count=$(tail -n +2 $destination_file | wc -l)
# Print to the console the number of lines that were processed
echo "$count records processed..."

# Cleanup temporary file
rm temp_file.csv

exit 0

