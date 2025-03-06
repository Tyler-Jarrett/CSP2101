#!/bin/bash

mkdir $1
touch "$1/$2"

echo "The [$1] directory has been successfully created and populated with [$2]"

exit 0