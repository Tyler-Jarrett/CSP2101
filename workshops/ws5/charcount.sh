#!/bin/bash

# This script counts strings from an input file that meet two (2) requirements:
#   1) start with a capital letter, and
#   b) contain no less than three (3) and no more than four (4) numbers.

read -p "Enter file name: " input_file

if [[ ! -f "$input_file" ]]; then
  echo "File '$input_file' not found."
  exit 1
fi

valid_count=0

while IFS= read -r line || [ -n "$line" ]; do
  # Extract the first character and verify it's uppercase
  first_char=$(echo "$line" | cut -c1)
  if [[ "$first_char" =~ [A-Z] ]]; then
    starts_with_cap1=true
  else
    starts_with_cap1=false
  fi

  # Use grep to check if line starts with a capital letter
  if echo "$line" | grep -qE "^[A-Z]"; then
    starts_with_cap2=true
  else
    starts_with_cap2=false
  fi

  # If either check fails, skip processing this line
  if [[ "$starts_with_cap1" != true || "$starts_with_cap2" != true ]]; then
    continue
  fi

  # Loop through each character
  digit_count_method1=0
  for (( i=0; i<${#line}; i++ )); do
    char=$(echo "$line" | cut -c $((i+1)))
    if [[ "$char" =~ [0-9] ]]; then
      digit_count_method1=$((digit_count_method1+1))
    fi
  done

  # Use grep to count digits
  digit_count_method2=$(echo "$line" | grep -o "[0-9]" | wc -l)

  # Make sure both counts agree (they should always match)
  if [[ "$digit_count_method1" -ne "$digit_count_method2" ]]; then
    echo "Warning: Counts don't match for line: $line"
  fi

  # Check that digit count matches number count rule
  valid_digits=false
  if [[ "$digit_count_method1" -eq 3 ]]; then
    valid_digits=true
  fi
  if [[ "$digit_count_method1" -eq 4 ]]; then
    valid_digits=true
  fi

  # Check if digit count doesn't match number count rule
  if [[ "$valid_digits" == true ]]; then
    if [[ "$digit_count_method1" -lt 3 ]]; then
      valid_digits=false
    fi
    if [[ "$digit_count_method1" -gt 4 ]]; then
      valid_digits=false
    fi
  fi

  # Increment counter if all conditions are met
  if [[ "$starts_with_cap1" == true && "$starts_with_cap2" == true && "$valid_digits" == true ]]; then
    valid_count=$((valid_count+1))
  fi
done < "$input_file"

echo "Count of valid strings: $valid_count"

exit 0