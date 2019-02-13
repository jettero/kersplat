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

function dcprune() {
    docker container prune < <(yes)
}

function diprune() {
    docker image ls | grep "^$DHUB_REPO" \
        | awk '{print $2}' \
        | grep -v "^$IMAGE_TAG" \
        | grep -v '<none>' \
        | sort -u \
        | xargs -rn1 -I{} docker rmi "$DHUB_REPO:{}"
    docker image prune < <(yes)
}

function dprune() {
    dcprune
    diprune
}

function dbuild() {
    if [ -n "$1" ]; then
        NOW="$(git symbolic-ref --short HEAD)"
        git co "$1" || exit 1
        source "$(dirname "$0")"/vars.sh
    else unset NOW
    fi

    cmd=( docker image build -t "$IMAGE_NAME" )

    if [ -n "$build_proxy" ]; then
        # NOTE: for custom ENV names, you have to define an ARG in the
        # Dockerfile; but several default ARGs exist that automatically map to
        # ENV. https://docs.docker.com/engine/reference/builder/#predefined-args
        cmd+=( --build-arg "http_proxy=http://$build_proxy/" )
        cmd+=( --build-arg "https_proxy=http://$build_proxy/" )
    fi

    ${JUST_ECHO:+echo} "${cmd[@]}" "$OS_DIR" || exit 1

    if [ -n "$NOW" ]
    then git co "$NOW"
    fi
}

function drun() {
    ( set | grep ^HUBBLE_
      set -x

      VA=( )
      for v in "${!volume[@]}"; do
          VA+=( --mount "type=bind,source=$(realpath "$v"),destination=$( realpath "${volume[$v]}" )" )
      done

      if [ -n "$AS_USER" ]
      then VA+=( --user "$AS_USER" )
      fi

      ${JUST_ECHO:+echo} \
          docker run "${VA[@]}" -ti --rm --name "$CONTAINER_NAME" "$IMAGE_NAME" "$@"
    )
}
