#!/bin/bash

declare -a num_list

while read -r num || [ -n "$num" ]; do
    num_list+=($num)
done < nums.txt

for line in ${num_list[@]}; do
    total=0
    len=${#line}

    for ((i=$len;i>0;i--)); do
        num=$(echo $line | cut -c $i) 
        let total+=num
    done

    printf "Sum of digits in %-5s - %d \n" $line $total

done

exit 0