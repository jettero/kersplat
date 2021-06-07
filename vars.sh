#!/bin/bash

cd "$(dirname "$0")" || exit 1
TOP_DIR="$(realpath -s "$(pwd)")"
TOP_BASENAME="$(basename "$TOP_DIR")"

source "$TOP_DIR/func.sh"

if [[ "$TOP_BASENAME" =~ ^[^-][^-]*-[^-][^-]*$ ]]; then
    DHUB_NAME="${DHUB_NAME:-$(cut -d- -f2 <<< "$TOP_BASENAME")}"
    DHUB_USER="${DHUB_USER:-$(cut -d- -f1 <<< "$TOP_BASENAME")}"
else
    DHUB_NAME="${DHUB_NAME:-$TOP_BASENAME}"
    DHUB_USER="${DHUB_USER:-$USER}"
fi

DHUB_REPO="$DHUB_USER/$DHUB_NAME"

IV="$(git describe --always --long | sed -e 's/-[a-z0-9]*$//' -e 's/-0$//' | sed -e s/^v//)"
OSI="${OSI:-debian:10}"
tmp="${OSI##*/}"
OSR="${tmp%%:*}"
OSV="${tmp##*:}"
OSD="Dockerfile.$OSR$OSV"

if docker build --help | grep -qs buildx
then BUILD_TYPE=buildx
else BUILD_TYPE=build
fi

case "$JUST_ECHO" in
    F*|f*|n*|N*|0) unset JUST_ECHO ;;
    default) JUST_ECHO=1 ;;
esac

IMAGE_NAME="$DHUB_REPO:$IV"
CONTAINER_NAME="kersplat-$IV"

var_color=$'\e[0;35m'
val_color=$'\e[1;35m'
rst=$'\e[m'

echo "${var_color}TOP_DIR:           ${val_color}${TOP_DIR}${rst}"
echo "${var_color}JUST_ECHO:         ${val_color}${JUST_ECHO}${rst}"
echo "${var_color}OSI (dist:ver):    ${val_color}${OSI}${rst}"
echo "${var_color}OSR (dist):        ${val_color}${OSR}${rst}"
echo "${var_color}OSV (version):     ${val_color}${OSV}${rst}"
echo "${var_color}OSD (dockerfile):  ${val_color}${OSD}${rst}"
echo "${var_color}DHUB_USER:         ${val_color}${DHUB_USER}${rst}"
echo "${var_color}DHUB_NAME:         ${val_color}${DHUB_NAME}${rst}"
echo "${var_color}DHUB_REPO:         ${val_color}${DHUB_REPO}${rst}"
echo "${var_color}IMAGE_NAME:        ${val_color}${IMAGE_NAME}${rst}"
echo "${var_color}CONTAINER_NAME:    ${val_color}${CONTAINER_NAME}${rst}"

unset var_color val_color rst tmp

[ -n "$VAR_ONLY" ] && exit 0
