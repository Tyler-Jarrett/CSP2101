#!/bin/bash

read -p "Enter commission earned: " commission

if [ $commission -le 200 ]; then
    echo "No bonus applicable, work harder!"
    exit 0
elif [ $commission -le 300 ]; then
    bonus=50
else
    bonus=100
fi

echo "The bonus applicable is $bonus dollars"

exit 0