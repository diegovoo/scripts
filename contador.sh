#!/bin/bash

valuefile="/tmp/value.dat"

# if we don't have a file, start at zero
if [ ! -f "$valuefile" ]; then
    value=0

# otherwise read the value from the file
else
    value=$(cat "$valuefile")
fi

if [ $# != 0 ]; then

# increment the value
if [ $1 = "++" ]; then
value=$((value + 1))
fi

if [ $1 = "--" ]; then
value=$((value -1))
fi

if [ $1 = "reset" ]; then
value=0
fi

    if [ $1 = "h" ] || [ $1 = "-h" ] || [ $1 = "--h" ]; then
        echo "usage:

    + cont -> returns value; value is saved in tmp file 
              therefore it resets when pc shuts down

    + cont+ -> adds 1 to value

    + cont- -> takes away 1 from value

    + contreset -> sets value to 0"
        exit 0
    fi
fi

# show it to the user
echo "value: ${value}"

# and save it for next time
echo "${value}" > "$valuefile"
