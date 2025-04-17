#!/bin/bash

# This script scans the files in a nominated directory and outputs their size on disk in Mb, Kb or b.

RED='\033[0;31m' # to colour error messages
GREEN='\033[0;32m' # to highlight key output values
BLUE='\033[0;34m' # for output headers
NC='\033[0m' # switches off the application of a colour to oputput

# The getsize() function coverts file sizes in bytes to Kb or Mb where applicable
getsize() {
    let mb=1048576 # number of bytes in a megabyte
    let kb=1024 # number of bytes in a kilobyte
    if [[ $1 -ge $mb ]]; then
        echo "$(echo $1 | awk '{printf "%.2f", $1/1024/1024}')Mb"
    elif [[ $1 -ge $kb ]]; then
        echo "$(echo $1 | awk '{printf "%.2f", $1/1024}')Kb"
    else
        echo "$1b"
    fi
}

# If temp.txt file exists from last run, delete it
if [[ -f temp.txt ]]; then
    rm temp.txt
fi

# get the directory and path option from the user
echo -e "Please provide path to directory to scan and a path option, e.g. ${GREEN}~/docs f${NC}"
echo -e "PATH OPTIONS: ${BLUE}f${NC} -> full path, ${BLUE}c${NC} -> current directory, ${BLUE}s${NC} -> child directory)"
read -p "Enter a valid directory and path option: " dir opt

# if either of the requested values is missing, inform user and exit script with error code
if [[ -z $dir ]] || [[ -z $opt ]]; then
    echo -e "${RED}One or more arguments have not been provided. Exiting...${NC}" && exit 1
fi

# If dir var contains a value, strip leading and trailing path delimiters
dir=`echo $dir | sed 's/^[~/]//' | sed 's/\/$]//'`

# check that the path/dir provided exists, and if so, assign to path variable for later use
case $opt in
    f|F) # if full path option is selected
        if ! [[ -d ${HOME}${dir} ]]; then # if the path/dir does not exist, inform user and exit script with error code
            echo -e "${RED}Directory does not exist. Exiting...${NC}" && exit 1
        else
            path=$(echo -n "${HOME}${dir}/*") # else assign valid path to variable with wildcard operator
        fi
    ;;
    c|C|s|S) # if cwd or subdirectory path option is selected
        if ! [[ -d ${dir} ]]; then # if the path/dir do not exist, inform user and exit script with error code
            echo -e "${RED}Directory does not exist. Exiting...${NC}" && exit 1
        else
            path=$(echo -n "${dir}/*") # else assign valid path to variable with wildcard operator
        fi
    ;;
    *) echo -e "${RED}Invalid path option. Exiting...${NC}" && exit 1 # if an invlalid path option is given
    # inform user and exit script with error code
esac

echo -e "${BLUE}FILENAME\tFILESIZE${NC}" # print out a header for the results
for item in $path # loop through each item in the target directory
do
    if [[ -f $item ]]; then # if a file
        fname=$(basename $item) # extract basename and assign to var
        fsize=$(getsize $(du -b $item | cut -f 1)) # get adjusted size of file using custom function
        echo $fname $fsize | awk '{printf "%-15s %-10s \n", $1,$2}' >> temp.txt # print out the results using awk to a file
    fi
done

cat temp.txt | sort --ignore-case -k 1 # output the results in temp.txt file ordered a-z (case-insensitive)

exit 0