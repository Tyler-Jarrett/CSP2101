#!/bin/bash
# Student name: Tyler Schwehr
# Student number: 10325932

# Validation checks that enough arguments have been provided, the source file exists, and both the source and destination files are .csv
# I considered doing a check to make sure that the destination did not exist, but concluded that it's the user's choice whether or not to overwrite a file
if [[ ! $# -eq 2 ]] || [[ ! -f $1 ]] || [[ ! $1 =~ .csv$ ]] || [[ ! $2 =~ .csv$ ]]; then
    # Print error message to provide meaningful feedback to user
    echo "One or more arguments are either missing or invalid, this command should be run with the source csv file and destination csv file"
    # Exit with an error code
    exit 1
fi

# Convert arguments to named variables for improved readability
source_file=$1
destination_file=$2

# Print the processing statement
echo "Processing..."

    # Convert the date to the correct format, this is an area where sed makes it a lot easier
    # Convert spaces to commas, it will make it easier for awk later
    # Output to a temporary file for easy management, while piping is an option, I feel this is more readable
sed -e 's#\[\([0-9]*\)/\([a-zA-Z]*\)/\([0-9]*\):[0-9]*:[0-9]*:[0-9]*#\1/\2/\3#g' \
    -e 's# #,#g' $source_file > temp_file.csv

    # Using awk to process the rest of the changes, as awk is great for modifying files, particularly csv files
    # The BEGIN statement sets the field seperator to a comma as that's the format that I am providing
    # I also set the first line of the file within the BEGIN as I only need that line once and at the start
    # For the body of the awk, I set the pattern to match every line except the first one
    # The substring command is used to exclude the first / character from the fourth column
    # I chose to do this in awk instead of sed because the field has multiple / characters and without a consistent pattern I could not reliably get the correct /
    # I use the substitution command to remove the url arguments
    # I chose to do this in awk for a similar reason, finding a consistent point to stop sed was challenging and would overrun the field, where awk is only viewing that field
    # Finally I use printf to output everything to the destination file, which I have to add back the commas
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

