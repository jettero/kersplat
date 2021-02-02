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

IV="$(git describe --always --long | sed -e 's/-[a-z0-9]*$//' -e 's/-0$//' )"
OSI="centos:8"
tmp="${OSI##*/}"
OSR="${tmp%%:*}"
OSV="${tmp##*:}"
OSD="$TOP_DIR/$OSR"

IMAGE_TAG="$OSR-$IV"
IMAGE_NAME="$DHUB_REPO:$IMAGE_TAG"
CONTAINER_NAME="$IMAGE_TAG"

var_color=$'\e[0;35m'
val_color=$'\e[1;35m'
rst=$'\e[m'

echo "${var_color}TOP_DIR:        ${val_color}${TOP_DIR}${rst}"
echo "${var_color}OSI (dist:ver): ${val_color}${OSI}${rst}"
echo "${var_color}OSR (dist):     ${val_color}${OSR}${rst}"
echo "${var_color}OSV (version):  ${val_color}${OSV}${rst}"
echo "${var_color}OSD (conf dir): ${val_color}${OSD}${rst}"
echo "${var_color}DHUB_USER:      ${val_color}${DHUB_USER}${rst}"
echo "${var_color}DHUB_NAME:      ${val_color}${DHUB_NAME}${rst}"
echo "${var_color}DHUB_REPO:      ${val_color}${DHUB_REPO}${rst}"
echo "${var_color}IMAGE_TAG:      ${val_color}${IMAGE_TAG}${rst}"
echo "${var_color}IMAGE_NAME:     ${val_color}${IMAGE_NAME}${rst}"
echo "${var_color}CONTAINER_NAME: ${val_color}${CONTAINER_NAME}${rst}"

unset var_color val_color rst tmp

[ -n "$VAR_ONLY" ] && exit 0
