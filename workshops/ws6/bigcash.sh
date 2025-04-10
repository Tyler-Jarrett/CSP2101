#!/bin/bash

getsumlines(){
    grep -E "[$][0-9]{2,},[0-9]{3}" $1 > results.txt
}

getsumlines $1

exit 0