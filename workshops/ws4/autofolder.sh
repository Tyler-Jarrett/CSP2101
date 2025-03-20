#!/bin/bash

success=0
declare -a folder_array

while read -r var || [ -n "$var" ]; do
    folder_array+=($var)
done < foldernames.txt

for folder in ${folder_array[@]}; do
    if [ `expr length $folder` -le 14 ]; then
        let "success+=1"
        echo "Folder $folder has been successfully created"
    fi     
done

echo "The source file contained ${#folder_array[*]} names, out of which $success were created successfully"

exit 0