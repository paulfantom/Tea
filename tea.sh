#!/bin/sh
function wait {
    suffix=`echo "$1" | tail -c 2`
    number=`echo ${1::-1}`
    while [ `echo "$number > 0" | bc` -eq 1 ]; do
        echo "$number$suffix to go"
        if [ `echo "$number>1" | bc` -eq 1 ]; then
            wait=1
        else
            wait=$number
        fi
        sleep "$wait$suffix"
        number=`echo "$number-1" | bc`
    done
}

if [ "$#" -lt 1 ]; then
    echo "Usage: tea NUMBER[SUFFIX]... (like sleep)"
    exit 1
fi
for i; do wait $i; done
notify-send -a tea -i task-attempt "Tea is ready" "Hurray!!!"
