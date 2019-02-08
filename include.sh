#!/bin/bash

source "$(dirname "$0")"/vars.sh

if [ -n "$TOP_DIR" -a -d "$TOP_DIR" ]
then cd "$TOP_DIR" || exit 1
else "Something is wrong with the vars.sh file"
fi

declare -A volume

if [ ! -f "$OS_DIR/Dockerfile" ]; then
    echo "then make a $OS/Dockerfile"
    exit 1
fi

rst=$'\e[m'
var_color=$'\e[1;35m'
val_color=$'\e[35m'

function dprune() {
    docker container prune < <(yes)
    docker image ls | grep "^$DHUB_REPO" \
        | awk '{print $2}' \
        | grep -v "^$IMAGE_TAG" \
        | grep -v '<none>' \
        | sort -u \
        | xargs -rn1 -I{} docker rmi "$DHUB_REPO:{}"
    docker image prune < <(yes)
    echo
}

function dbuild() {
    BUILD_DIR="$(dirname "$OS_DIR")/.bd"
    rsync -a --delete "$OS_DIR/" "$BUILD_DIR"
    sed -i -e "s/^FROM .*/FROM $OS:$OSV/" "$BUILD_DIR/Dockerfile"

    if [ -n "$build_proxy" ]; then
        sed -i \
            -e 's/^#.*\(ENV.*PROXY.*\)/\1/' \
            -e "s/PROXY_IP:PROXY_PORT/$build_proxy/" \
            "$BUILD_DIR/Dockerfile"
    fi

    echo -n $'\e[1;30m'
    diff -u "$OS_DIR/Dockerfile" "$BUILD_DIR/Dockerfile"
    echo -n $'\e[m'

    ${JUST_ECHO:+echo} \
        docker image build -t "$IMAGE_NAME" build-dir || exit 1
}

function drun() {
    ( set | grep ^HUBBLE_
      set -x

      VA=( )
      for v in "${!volume[@]}"; do
          VA+=( --mount "type=bind,source=$(realpath "$v"),destination=$( realpath "${volume[$v]}" )" )
      done

      ${JUST_ECHO:+echo} \
          docker run "${VA[@]}" -ti --rm --name "$CONTAINER_NAME" "$IMAGE_NAME" "$@"
    )
}
