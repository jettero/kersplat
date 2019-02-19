#!/bin/bash

TOP_FILE="$(realpath "$0")"
TOP_DIR="$(dirname "$TOP_FILE")"

source "$TOP_DIR/func.sh"

DHUB_USER="${DHUB_USER:-$USER}"
DHUB_NAME="$(basename "$TOP_DIR")"
DHUB_REPO="$DHUB_USER/$DHUB_NAME"

IV="$(git describe --always)"
OSI="${OSI:-centos:latest}"
if [[ "$OSI" =~ / ]]
then OSO="${OSI%%/*}"
else OSO=""
fi
tmp="${OSI##*/}"
OSR="${tmp%%:*}"
OSV="${tmp##*:}"
echo "WTF!! OSD=OSO=$OSO[[${OSO:+-}]]OSR=$OSR"
OSD="$OSO${OSO:+-}$OSR"
OS_DIR="$TOP_DIR/$OSD"

IMAGE_TAG="$OSD-$IV"
IMAGE_NAME="$DHUB_REPO:$IMAGE_TAG"
CONTAINER_NAME="$IMAGE_TAG"

var_color=$'\e[0;35m'
val_color=$'\e[1;35m'
rst=$'\e[m'

echo "${var_color}TOP_DIR:        ${val_color}${TOP_DIR}${rst}"
echo "${var_color}OSI:            ${val_color}${OSI}${rst}"
echo "${var_color}OSO:            ${val_color}${OSO}${rst}"
echo "${var_color}OSR:            ${val_color}${OSR}${rst}"
echo "${var_color}OSV:            ${val_color}${OSV}${rst}"
echo "${var_color}OSD:            ${val_color}${OSD}${rst}"
echo "${var_color}DHUB_USER:      ${val_color}${DHUB_USER}${rst}"
echo "${var_color}DHUB_NAME:      ${val_color}${DHUB_NAME}${rst}"
echo "${var_color}DHUB_REPO:      ${val_color}${DHUB_REPO}${rst}"
echo "${var_color}IMAGE_TAG:      ${val_color}${IMAGE_TAG}${rst}"
echo "${var_color}IMAGE_NAME:     ${val_color}${IMAGE_NAME}${rst}"
echo "${var_color}CONTAINER_NAME: ${val_color}${CONTAINER_NAME}${rst}"

unset var_color val_color rst tmp

[ -n "$VAR_ONLY" ] && exit 0
