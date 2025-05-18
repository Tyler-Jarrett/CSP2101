#!/bin/bash

a=true
b=false

if $a; then
    echo "a is true"
fi

if [[ $a -eq true ]]; then
    echo "a does -eq true"
fi

if [[ $a = true ]]; then
    echo "a does = true"
fi

if $b; then
    echo "b is true"
fi

if [[ $b -eq true ]]; then
    echo "b does -eq true"
fi

if [[ $b = true ]]; then
    echo "b does = true"
fi

exit 0