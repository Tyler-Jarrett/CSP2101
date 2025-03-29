#!/bin/bash

RED='\033[31m'
GREEN='\033[32m'
NC='\033[0m'  # No Color / reset

# Prompt the user for a file name, store it in input_file
read -p "Enter file name: " input_file

# Check if the file does not exist
if [[ ! -f "$input_file" ]]; then
  # Print an error and exit program
  echo "File '$input_file' not found."
  exit 1
fi

# Set the input field separator to blank spaces, loop over every line
while IFS= read -r line || [ -n "$line" ]; do
  # If the line only contains one or more series of characters, starting with any number of capitals or numbers
  # followed by a hash, exclaimation mark, any character, underscore, and a hyphen.
  if [[ $line =~ ^[A-Z0-9*\#!._\-]+$ ]]; then
    # Print the line in a 25 width column, followed by a green allowed statement
    printf "%-25s ${GREEN}[allowed]${NC}\n" "$line"
  else
  # Print the line in a 25 width column, followed by a red disallowed statement
    printf "%-25s ${RED}[disallowed]${NC}\n" "$line"
  fi
  # Redirect the input file into the loop
done < "$input_file"

exit 0