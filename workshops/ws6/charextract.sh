#!/bin/bash

cntlc(){
    # Initialise count, pattern, and type variable
    local cnt=0 patt="" type=""
    # Initialise chartype array with potential types
    declare -a chartype=("vowels" "consonants" "numbers")

    # Check the type argument and set the pattern and type 
    case $2 in
        v) patt="[AEIOUaeiou]"; type="${chartype[0]}";;
        c) patt="[B-DF-HJ-NP-TV-Zb-df-hj-np-tv-z]"; type="${chartype[1]}";;
        n) patt="[0-9]"; type="${chartype[2]}";;
    esac
    
    # Set the count to the length of the word given
    cnt=${#1}
    # Print the word and type to the user
    echo -n "The string $1 contains the following $type - "
    # Loop over each character in the word
    for ((i=$cnt;i>0;i--))
        do
            # Extract the character
            ch=$(echo $1 | cut -c $i)
            # If the character matches the pattern
            if [[ $ch =~ $patt ]]; then
                # Print the character out
                echo -n "$ch "
            fi
        done
        echo -e "\n"
}

# Check that the number of passed arguments equals 1
if ! [[ $# -eq 1 ]]; then
    # Print error for incorrect number of arguments
    echo "Invalid or missing argument. Require -v, -c or -n" && exit 1
else
    # Prompt the user for a word to process
    read -p "Please provide word to process: " wrd
    # Extract the options out from the passed argument
    while getopts 'vcn' opt
        do
            # Pass the word and the selected option to the function
            case $opt in
                v) cntlc $wrd $opt
                ;;
                c) cntlc $wrd $opt
                ;;
                n) cntlc $wrd $opt
                ;; 
                # Print an error statement if the selection is invalid
                *) echo "Invalid flag. Exiting..." && exit 1
                ;;
            esac
        done
fi

exit 0