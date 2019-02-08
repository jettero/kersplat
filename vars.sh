#!/bin/bash

TOP_FILE="$(realpath "$0")"
TOP_DIR="$(dirname "$TOP_FILE")"

DHUB_USER="${DHUB_USER:-$USER}"
DHUB_NAME="$(basename "$TOP_DIR")"
DHUB_REPO="$DHUB_USER/$DHUB_NAME"

IV="$(git describe --always)"
OS="${OS:-centos}"
OS_DIR="$TOP_DIR/$OS"
OSV="${OSV:-latest}"

if [[ "$OS" =~ : ]]; then
    OSV="$( cut -d: -f2 <<< "$OS" )"
     OS="$( cut -d: -f1 <<< "$OS" )"
fi

IMAGE_TAG="$OS-$IV"
IMAGE_NAME="$DHUB_REPO:$IMAGE_TAG"
CONTAINER_NAME="$( sed -e 's/[^a-zA-Z0-9][^a-zA-Z0-9]*/-/g' <<< "$IMAGE_NAME" )"

echo "${var_color}TOP_DIR:        ${val_color}${TOP_DIR}${rst}"
echo "${var_color}OS:OSV:         ${val_color}${OS}:${OSV}${rst}"
echo "${var_color}OS_DIR:         ${val_color}${OS_DIR}${rst}"
echo "${var_color}DHUB_USER:      ${val_color}${DHUB_USER}${rst}"
echo "${var_color}DHUB_NAME:      ${val_color}${DHUB_NAME}${rst}"
echo "${var_color}DHUB_REPO:      ${val_color}${DHUB_REPO}${rst}"
echo "${var_color}IMAGE_TAG:      ${val_color}${IMAGE_TAG}${rst}"
echo "${var_color}IMAGE_NAME:     ${val_color}${IMAGE_NAME}${rst}"
echo "${var_color}CONTAINER_NAME: ${val_color}${CONTAINER_NAME}${rst}"

[ -n "$VAR_ONLY" ] && exit 0
