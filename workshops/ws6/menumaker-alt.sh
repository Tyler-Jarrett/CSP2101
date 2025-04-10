#!/bin/bash

makemenu(){
    printf "%-8s %s \n" "22" "1)"
    printf "%-8s %s \n" "23" "2)"
    printf "%-8s %s \n" "53" "3)"
    printf "%-8s %s \n" "161" "4)"
    printf "%-8s %s \n" "1080" "5)"
    printf "%-8s %s \n" "6660" "6)"
    printf "%-8s %s \n" "31337" "7)"
    input -p "Please select your port: " selection
}

makemenu $1

exit 0
