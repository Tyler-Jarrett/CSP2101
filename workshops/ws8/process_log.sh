#!/bin/bash

# This bash script that reads through the records in the attached .csv file, and displays records to the screen that meet the following criteria:
    # The time is in the Time field is in the PM only
    # The PID field is empty
    # The Component field contains the string "kernel"
# The output to the terminal should be four columns as per the example below:
# LineId    DateTime		Component	EventTemplate
# 1994	    Jul-27@14:41	kernel		SELinux:  Registering netfilter hooks

filename="$1"
line_number=0
matches=0

echo -e "LineId\tDateTime\tComponent\tEventTemplate"

while IFS=',' read -r LineId Month Date Time Level Component PID Content EventId EventTemplate
do
    if [[ $line_number -eq 0 ]]; then
        ((line_number++))
        continue
    fi

    # Get hour part (before ':') of time
    hour=$(echo "$Time" | cut -d':' -f1 | sed 's/^0*//')

    # Check if hour is 12 or greater
    if [[ $hour -ge 12 ]]; then
        # Check if PID is empty
        if [[ -z "$PID" ]]; then
            # Check if component contains "kernel"
            contains_kernel=$(echo "$Component" | grep "kernel")
            if [[ ! -z "$contains_kernel" ]]; then
            ((matches++))
                # Format Time with Date
                datetime="$Month-$Date@$Time"
                # Output
                echo -e "${LineId}\t${datetime}\t${Component}\t${EventTemplate}"
            fi
        fi
    fi

    ((line_number++))

done < "$filename"

echo "A total of $matches matches were found."

exit 0