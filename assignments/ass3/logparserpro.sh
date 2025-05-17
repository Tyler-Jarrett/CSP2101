#!/bin/bash
# Student name: Tyler Schwehr
# Student number: 10325932

formatRecords() 
{
        # Convert the date to the correct format, this is an area where sed makes it a lot easier
        # Convert spaces to commas, it will make it easier for awk later
        # Output to a temporary file for easy management, while piping is an option, I feel this is more readable
    sed -e 's#\[\([0-9]*\)/\([a-zA-Z]*\)/\([0-9]*\):[0-9]*:[0-9]*:[0-9]*#\1/\2/\3#g' \
        -e 's# #,#g' $1 > temp_file.csv

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
            }' temp_file.csv > $2

    # Cleanup temporary file
    rm temp_file.csv
}

basic_mode=true
zip_mode=false
single_mode=false
double_mode=false
search_string="_"

while getopts "s:d:z" opt; do
    case $opt in
        s) 
            single_mode=true 
            basic_mode=false
            search_string=$OPTARG
            ;;
        d) 
            double_mode=true
            basic_mode=false
            search_string=$OPTARG
            ;;
        z) 
            zip_mode=true
            ;;
        *) 
            echo -e "$OPTERR"
            exit 1
            ;;
    esac
done

if [[ $single_mode = true ]] && [[ $double_mode = true ]]; then
    echo "-s and -d flags can't be used together. Exiting..."
    exit 1
elif [[ $zip_mode = true ]] && [[ $basic_mode = true ]]; then
    echo "Search option -s or -d must be used in this context. Exiting..."
    exit 1
fi

if $basic_mode; then
    while true; do

        read -p "Please provide the nameof the source web log and results output file: " source_file destination_file

        if [[ -f $source_file ]] && [[ $source_file =~ .csv$ ]] && [[ $destination_file =~ .csv$ ]]; then
            break        
        fi

        echo "One or more of the file names is invalid, both file names should be a csv, and the source file must exist"
    done
else
    while true; do 

        read -p "Please provide the name of the source web log file: " source_file
    
        if [[ -f $source_file ]] && [[ $source_file =~ .csv$ ]]; then 
            break
        fi

        echo "The source file must already exist and be a csv, try again"
    done

    destination_file="$(date '+%Y_%m_%d_%H_%M_%S')_fltargs_$(echo $search_string | sed s'/,/_/').csv"

fi

# Print the processing statement
echo "Processing..."

formatRecords $source_file $destination_file

if $zip_mode; then
    zip_destination="$(basename $destination_file ".csv").zip"
    zip $zip_destination $destination_file 
fi

# Get the total number of lines, excluding the heading
count=$(tail -n +2 $destination_file | wc -l)
# Print to the console the number of lines that were processed
echo "$count records processed..."

exit 0

