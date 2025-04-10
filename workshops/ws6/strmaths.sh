#!/bin/bash

if [ ! -f "$1" ]; then
    echo "File does not exist!"
    exit 1
fi

if (( "$2" != "-a" || "$2" != "-m" )); then
    echo "You must supply either -a for add or -m for multiply."
    exit 1
fi

matches=""
result=0
matchcnt=0
charcnt=0
while read line; do
    charcnt=${#line}
    for (( i=$charcnt; i>0; i-- )); do
        char=$(echo "$line" | cut -c $charcnt)
        if [[ $char =~ [0-9] ]]; then
        matches+="$char"
        fi
        ((charcnt--))
    done
    # echo "$matches"
    matchcnt=${#matches}
    if [[ $matchcnt -gt 0 ]]; then
        for (( i=$matchcnt; i>0; i-- )); do
            temp=$(echo "$matches" | cut -c $matchcnt)
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