#!/bin/bash

makemenu(){

    local ports=$(cut -d , -f 1 $1 | sort | uniq)

    for port in $ports; do
        printf "[%s] " "$port"
    done
    echo

    read -p "Select a port from the above list to analyse: " selected
    echo "$selected"
}

read -p "Please select which file you would like to analyse? " selfile

makemenu $selfile

exit 0