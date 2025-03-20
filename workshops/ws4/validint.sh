#!/bin/bash


while true; do

    read -p "Please enter an integer between 110 and 150: " num

    if [ $num -z ]; then
        echo "You didn't type anything, try again!"

    elif [ $num -lt 110 ]; then
        echo "That number is too low"
        continue

    elif [ $num -gt 150 ]; then
        echo "That number is too high"
        continue

    else
        echo "Alright, that number is valid"
        break

    fi

done


exit 0