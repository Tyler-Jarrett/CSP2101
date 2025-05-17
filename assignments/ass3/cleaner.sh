#!/bin/bash

for file in ./*; do
    if [[ -f $file ]] && [[ $file =~ ^./2025_ ]]; then
        rm "$file"
    fi
done


exit 0