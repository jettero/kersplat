#!/bin/bash

function join {
    local IFS="$1"; shift
    if [ $# = 0 ]; then
        readarray -t T < <( cat )
        set -- "${T[@]}"
    fi
    echo "$*"
}

function lsplit {
    local IFS="$1"; shift
    for i in "$@"
    do tr "$IFS" '\n' <<< "$i"
    done
}

