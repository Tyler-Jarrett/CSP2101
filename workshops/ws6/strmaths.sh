#!/bin/bash

# Check to see if the file exists
if [ ! -f "$1" ]; then
    echo "File does not exist!"
    exit 1
fi

# Not a correct if statement, should be square brackets and using the -ne operator
if (( "$2" != "-a" || "$2" != "-m" )); then
    echo "You must supply either -a for add or -m for multiply."
    exit 1
fi

matches=""
result=0
matchcnt=0
charcnt=0

# This will ignore the final line in the file, because you don't capture lines without line end markers
while read line; do    
    charcnt=${#line}
    # Wrong exit condition, either count up or change it to less than 0
    for (( i=$charcnt; i>0; i-- )); do
        # This should be using $i
        char=$(echo "$line" | cut -c $charcnt)

        if [[ $char =~ [0-9] ]]; then
            matches+="$char"
        fi
        # You already have a decrementing integer, use that instead
        ((charcnt--))
    done

    # echo "$matches" - What is this for??
    matchcnt=${#matches}

    if [[ $matchcnt -gt 0 ]]; then
        # Should be inclusive of 0
        for (( i=$matchcnt; i>0; i-- )); do
            # Same problem as above, should be using $i
            temp=$(echo "$matches" | cut -c $matchcnt)
            # Wrong comparison, should be using the -eq
            if [ "$2" == "-a" ]; then
                result=$(($result + $temp))
            elif [ "$2" == "-m" ]; then
                if [[ $result -eq 0 ]]; then
                    result=$temp
                else
                    result=$(($result * $temp))
                fi
            else
                echo "Something went wrong" && exit 1
            fi
            ((matchcnt--))
        done

        if [ "$2" == "-a" ]; then
            echo "The sum of the numbers in $line is $result"
        elif [ "$2" == "-m" ]; then
            echo "The product of the numbers in $line is $result"
        else
            echo "Something went wrong" && exit 1
        fi
    fi
    matches=""
    result=0
    matchcnt=0
    charcnt=0
done < "$1"

exit 0