#!/bin/bash
# Student name: Tyler Schwehr
# Student number: 10325932

# I initialise my key variables, I've opted to use boolean values
# Boolean values do not work how a normal person would expect and require a certain degree of madness to operate
basic_mode=true
zip_mode=false
single_mode=false
double_mode=false
search_string=""

# Using getopt to pick up the flags passed into the script, both -s and -d require arguments and have been noted as much
# The only logic that I apply within the getopts loop is to set the switches and populate the search string
# I use the same method from the lectures for capturing getopts errors and simply print it to the user
# There is one problem that I can't solve, if the user inputs -sz it will use the z as the search string, if they use -dz it gets fixed later
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
            search_string=$OPTARG;;
        z) 
            zip_mode=true;;        
        *) 
            echo "Invalid flag selection. Exiting..."
            exit 1;;
    esac
done

# This is the validation block for all issues relating to incorrect flag usage
# Firstly I check if both single and double mode have been activated, print an error and exit
if [[ $single_mode = true ]] && [[ $double_mode = true ]]; then
    echo "-s and -d flags can't be used together. Exiting..."
    exit 1
# Next I check if they have activated the zip option but not selected the pro mode, print an error and exit
elif [[ $zip_mode = true ]] && [[ $basic_mode = true ]]; then
    echo "Search option -s or -d must be used in this context. Exiting..."
    exit 1
# Trying to figure out if they were entering arguments without flags was a challenge
# I'm a little proud of this, I check the number of arguments against how many times the getopts loop ran
# In normal usage, the $OPTIND value should always be greater than the number of arguments
elif [ $# -ge $OPTIND ]; then
    echo "Invalid flag selection. Exiting..."
    exit 1
# If double mode is active, I check that the argument has a comma and at least one character either side of it
# This doesn't prevent bad search terms but it does stop empty search terms
elif [[ $double_mode = true ]] && [[ ! $search_string =~ .+,.+ ]]; then
    echo "-d requires two arguments separated by a comma, e.g. arg1,arg2. Exiting..."
    exit 1
# Finally I check for attempts to do a double search term in single mode, and check for the getopts quirk if the user passes -sz together
elif [[ $1 = '-sz' ]] || [[ $search_string =~ , ]]; then
    echo "-s must have a valid argument which is a single search term and can't group -sz. Exiting..."
    exit 1
fi

# This segment is the validation block for preproccessing, making sure everything is right before working on the file
# If basic mode is active, I perform the standard prompt for getting the source and destination
if $basic_mode; then
    # I use an infinite loop for input validation
    while true; do
        # Provide the prompt and save the output to source and destination
        read -p "Please provide the name of the source web log and results output file: " source_file destination_file
        # If the source exists and both file names are csv's then exit the loop
        if [[ -f $source_file ]] && [[ $source_file =~ .csv$ ]] && [[ $destination_file =~ .csv$ ]]; then
            break        
        fi
        # Otherwise print the error message and loop again
        echo "You need to provide the name of an existing web log .csv file and a .csv file to write the results, e.g."
        echo -e "\t weblogname.csv processed.csv"
        echo "Please try again."
    done
# In the scenario where pro mode is active I perform a similar validation loop but only for the source file
else
    # Enter infinite loop
    while true; do 
        # Provide the prompt and save the output to source
        read -p "Please provide the name of the source web log file: " source_file
        # If the source file exists and is a csv exit the loop
        if [[ -f $source_file ]] && [[ $source_file =~ .csv$ ]]; then 
            break
        fi
        # Otherwise print the error message and loop again
        echo "You need to provide the name of an existing web log .csv file, e.g."
        echo -e "\t weblogname.csv"
        echo "Please try again."
    done
    # Create the name for the output file using the year_month_day_hour_minutes_seconds_searchArguements 
    destination_file="$(date '+%Y_%m_%d_%H_%M_%S')_fltargs_$(echo $search_string | sed s'/,/_/').csv"
fi

# Print the processing statement
echo "Processing..."

# This is the main processing block, each mode has its own branch to perform the logic according to its specific requirements
# Because each branch has its own processing requirements, I use different temp files and cleanup each in its own branch
if $basic_mode; then
    # For the basic mode, I remove the first line of the file, this solves a consistency problem with the pro mode
    # tail allows me to grab all lines except the first one, redirect to a temp file
    tail -n +2 $source_file > temp_source_file.csv
    
elif $single_mode; then
    # Filter the records using grep - I've opted for case insensitive because I prefer it
    grep -i "$search_string" "$source_file" > temp_source_file.csv

elif $double_mode; then
    # Using cut I separate the search terms
    first_term=$(echo "$search_string" | cut -d , -f 1)
    second_term=$(echo "$search_string" | cut -d , -f 2)    
    # I make two grep calls sequentially, filtering for both search terms - case insensitive again
    grep -i "$first_term" "$source_file" | grep -i "$second_term" > temp_source_file.csv
fi

# I've kept the code for processing almost the same as the last assessment, I have removed the body filter that skips the first line
# Because grep was naturally removing the first line, this caused pro mode to skip the first record
# As noted above the solution I've used is to remove the first line in basic mode instead

# Convert the date to the correct format, this is an area where sed makes it a lot easier
# Convert spaces to commas, it will make it easier for awk later
# Output to a temporary file for easy management, while piping is an option, I feel this is more readable
sed -e 's#\[\([0-9]*\)/\([a-zA-Z]*\)/\([0-9]*\):[0-9]*:[0-9]*:[0-9]*#\1/\2/\3#g' \
    -e 's# #,#g' temp_source_file.csv > temp_file.csv

# Using awk to process the rest of the changes, as awk is great for modifying files, particularly csv files
# The BEGIN statement sets the field seperator to a comma as that's the format that I am providing
# I also set the first line of the file within the BEGIN as I only need that line once and at the start
# The substring command is used to exclude the first / character from the fourth column
# I chose to do this in awk instead of sed because the field has multiple / characters and without a consistent pattern I could not reliably get the correct /
# I use the substitution command to remove the url arguments
# I chose to do this in awk for a similar reason, finding a consistent point to stop sed was challenging and would overrun the field, where awk is only viewing that field
# Finally I use printf to output everything to the destination file, which I have to add back the commas
awk 'BEGIN {
        FS=","; 
        print "IP,Date,Method,URL,Protocol,Status";
        }
        {
        $4 = substr($4, 2);
        sub(/?.*$/, "", $4);
        printf "%s,%s,%s,%s,%s,%s\n", $1,$2,$3,$4,$5,$6;        
        }' temp_file.csv > $destination_file

# Cleanup temporary files
rm temp_file.csv
rm temp_source_file.csv

# Get the total number of lines, excluding the heading
# Used the tail command to grab all lines except the first and counted how many were left using wc
count=$(tail -n +2 $destination_file | wc -l)
# If the count is 0 then I delete the output file - I don't think there's a better way of doing this without using the temp file for longer
if [ $count -eq 0 ]; then
    rm $destination_file
    echo "No matching records were found"
else
    # Print to the console the number of lines that were processed
    echo "$count records processed and the results written to $destination_file as requested"
fi

# If zip mode is active and the number of lines is greater than 0
if [[ $zip_mode = true ]] && [[ $count -gt 0 ]]; then
    # Create the zip file name, use basename to grab the filename and remove the extension, then add the .zip extension
    zip_destination="$(basename $destination_file ".csv").zip"
    # Run zip command in quiet mode
    zip -q $zip_destination $destination_file 
    # Print the message that the file has been successfully zipped
    echo "The results file has been zipped into $zip_destination as requested"
fi

exit 0

