#!/bin/bash

source "$(dirname "$0")"/vars.sh
source "$(dirname "$0")"/func.sh

declare -A volume

if [ ! -f "./$OSD" ]
then echo "no such file ./$OSD"; exit 1
fi

if [ -n "$TOP_DIR" -a -d "$TOP_DIR" ]
then cd "$TOP_DIR"
else "can't cd into $TOP_DIR"; exit 1
fi
