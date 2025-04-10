#!/bin/bash

while true; do
    read -p "Enter the name of the file to be processed: " filename

    if [[ -e $filename ]] && [[ -f $filename ]]; then
        break
    else
        echo "That's not a valid file"
    fi
done

while read -r line || [ -n "$line" ]; do
    echo $line | sed 's/\(.*\)\/\(.*\)\/\(.*\):\(.*\):\(.*\):\(.*\)/\1-\2-\3 \4h \5m \6s/'
    
done < $filename

exit 0