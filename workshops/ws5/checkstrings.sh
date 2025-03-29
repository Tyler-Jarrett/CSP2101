#!/bin/bash

RED='\033[31m'
GREEN='\033[32m'
NC='\033[0m'  # No Color / reset

read -p "Enter file name: " input_file

if [[ ! -f "$input_file" ]]; then
  echo "File '$input_file' not found."
  exit 1
fi

while IFS= read -r line || [ -n "$line" ]; do
  if [[ $line =~ ^[A-Z0-9*\#!._\-]+$ ]]; then
    printf "%-25s ${GREEN}[allowed]${NC}\n" "$line"
  else
    printf "%-25s ${RED}[disallowed]${NC}\n" "$line"
  fi
done < "$input_file"

exit 0