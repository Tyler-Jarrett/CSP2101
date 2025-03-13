#!/bin/bash

read -p "Please enter the name of the folder you want created: " dir_name

if [ -e $dir_name ]; then
    echo "Sorry, $dir_name already exists. Exiting.."
    exit 1
else
    mkdir $dir_name

    if [ -e $dir_name ]; then
        echo "The $dir_name folder has now been created"

    fi
fi

exit 0