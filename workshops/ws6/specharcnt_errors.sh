#!/bin/bash

# Function to count the number of special characters
count_special_chars() {
    # Take the first parameter and name it input_str
    local input_str="$1"
    # Grep for any non alphanumeric characters, deleting the line end
    local special_chars=$(echo "$input_str" | grep -o '[^a-zA-Z0-9]' | tr -d '\n')
    # Count the number of special characters found
    local count=${#special_chars}
    # Return the characters and the number of characters
    echo "$special_chars" "$count"
}

# Store the first argument as file variable
file="$1"

# Check that the file exists
if [ ! -f "$file" ]; then
    echo "File does not exist."
    exit 1
else
    # Print the header for the table
    printf "%-20s %-10s %-10s \n" "STRING" "COUNT" "MATCHES"
    # For every line in the file
    while read -r line || [ -n "$line" ]; do
        # Call the count special characters function, passing in the line
        result=$(count_special_chars "$line")
        # Cut the result, only taking the special characters
        specials=$(echo "$result" | cut -d' ' -f 1)
        # Cut the result, only taking the count of characters
        num_specials=$(echo "$result" | cut -d' ' -f 2)
        # If there is more than 0 special characters, print the line
        if [[ num_specials -ne 0 ]]; then
            printf "%-20s %-10s %-10s \n" "$line" "$num_specials" "$specials"
        fi
    done < "$file"
fi

exit 0