#!/bin/bash

declare -a num_list

while read -r num || [ -n "$num" ]; do
    num_list+=($num)
done < nums.txt

for line in num_list; do
    total=0
    for digit in read -n1 $num_list; do
        let total+=$digit

    done
    echo total

done

exit 0