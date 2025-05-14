#!/bin/bash

while getopts 'zs:d' opt; do
    case $opt in
        z) echo "The z option was selected";;
        s) echo "The single option was selected, it had the $OPTARG argument";;
        dz) echo "this is a dual option";;
        d) echo "The double option was selected";;
        *) echo -e "$OPTERR" && exit 1;;
    esac
done


echo "What is OPTIND $OPTIND"
echo "This is a generic message, nothing special to note"
exit 0