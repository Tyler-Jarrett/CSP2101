#!/bin/bash

if [[ $1 =~ ^.{,8}$ ]] && [[ $1 =~ [0-9]{3,} ]] && [[ $1 =~ [A-Z]+ ]] && [[ $1 =~ [a-z]+ ]]; then
    echo "Valid! You may enter."
else
    echo "Invalid! You may not enter"
    exit 1
fi

exit 0