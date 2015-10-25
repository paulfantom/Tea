#!/usr/bin/env bash
wait() {
    suffix=$(echo "$1" | tail -c 2)
    if [[ ! ${suffix} =~ [smdh] ]]; then
        suffix="s"
        number=$1
    else
        number=${1::-1}
    fi
    while [ $(echo "$number > 0" | bc) -eq 1 ]; do
        echo "$number$suffix to go"
        if [ $(echo "$number>1" | bc) -eq 1 ]; then
            wait=1
        else
            wait=$number
        fi
        sleep "$wait$suffix"
        number=$(echo "$number-1" | bc)
    done
}

if [ "$#" -lt 1 ]; then
    echo "Usage: tea NUMBER[SUFFIX]... (like sleep)"
    exit 1
fi

for i; do wait $i; done
eject 2> /dev/null
notify-send -a tea -i task-attempt "Tea is ready" "Hurray!!!"
paplay /usr/share/sounds/freedesktop/stereo/bell.oga
