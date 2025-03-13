#!/bin/bash

if [ ! -e $1 ]; then
    echo "validation has failed"
    exit 1
fi

if ! ([[ $2 -ge 10 ]] && [[ $2 -le 20 ]]); then
    echo "validation has failed"
    exit 1
fi

echo "All validations passed"
exit 0