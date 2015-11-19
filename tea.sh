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
        echo -e "\033[36m$number$suffix\033[0m to go"
        if [ $(echo "$number>1" | bc) -eq 1 ]; then
            wait=1
        else
            wait=$number
        fi
        sleep "$wait$suffix"
        number=$(echo "$number-1" | bc)
    done
}

notify() {
  eject 2>/dev/null
  notify-send -a tea -i task-attempt "Tea timer" "$1"
  paplay /usr/share/sounds/freedesktop/stereo/bell.oga
}

if [ "$#" -lt 1 ]; then
    echo "Usage: tea NUMBER[SUFFIX] [NUMBER[SUFFIX]]"
    exit 1
fi

WAIT_TIME=""
BREW_TIME=""

if [ "$2" ]; then
  WAIT_TIME="$1"
  BREW_TIME="$2"
else
  BREW_TIME="$1"
fi

if [ ! -z "$WAIT_TIME" ]; then
  wait $WAIT_TIME
  notify "Water reached optimal temperature."
  ACK=""
  echo -e "\033[33mWater has reached the optimal temperature.\nPut tea into the water, close CD tray (if open) and press any key\033[0m"
  read -n 1 ACK
fi

wait $BREW_TIME
echo -e "\033[32mYour Tea is ready\033[0m"
notify "Tea is ready."
