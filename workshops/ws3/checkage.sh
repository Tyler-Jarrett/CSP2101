#!/bin/bash

echo -e "Please enter your age \n(You must be over 18 to pass):"
read age

if [ $age -ge 18 ]; then
    echo "OK, you can pass then"
else
    echo "YOU SHALL NOT PASS"
fi

exit 0