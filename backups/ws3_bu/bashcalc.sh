#!/bin/bash

case $1 in 
    "a") let sum=$2+$3
    echo $sum
    ;;
    "s") let diff=$2-$3
    echo $diff
    ;;
    "m") let prod=$2*$3
    echo $prod
    ;;
    "d") let div=$2/$3
    echo $div
    ;;
    "e") let "exp=$2 ** $3"
    echo $exp
    ;;
    *)
        echo "That's not a valid operation, try again"
        exit 1
    ;;
esac

exit 0