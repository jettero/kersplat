#!/bin/bash

function ifold {
    # split super long lines on spaces and indent following rows
    local cmf=$(( COLUMNS - 3 ))
    echo
    fold -w $cmf -s | sed -e '2,$s/^/  /'
    echo
}

function dcprune {
    docker container prune < <(yes)
}

function diprune {
    docker image ls | grep "^$DHUB_REPO" \
        | awk '{print $2}' \
        | grep -Ev "^(centos-v$IV|$IV)" \
        | grep -v '<none>' \
        | sort -u \
        | xargs -rn1 -I{} docker rmi "$DHUB_REPO:{}"
    docker image prune < <(yes)
}

function dprune {
    dcprune
    diprune
}

function dbuild {
    if [ -n "$1" ]; then
        NOW="$(git symbolic-ref --short HEAD)"
        git co "$1" || exit 1
        source "$(dirname "$0")"/vars.sh
    else unset NOW
    fi

    cmd=( docker image build --force-rm )
    if [ $BUILD_TYPE = buildx ]
    then cmd+=( --load )
    fi
    cmd+=( -t "$IMAGE_NAME" -f "./$OSD" . )

  # if [ -n "$build_proxy" ]; then
  #     # NOTE: for custom ENV names, you have to define an ARG in the
  #     # Dockerfile; but several default ARGs exist that automatically map to
  #     # ENV. https://docs.docker.com/engine/reference/builder/#predefined-args
  #     cmd+=( --build-arg "http_proxy=http://$build_proxy/" )
  #     cmd+=( --build-arg "https_proxy=http://$build_proxy/" )
  # fi

    ifold <<< "${cmd[*]}"

    if [ -z "$JUST_ECHO" ]
    then "${cmd[@]}" || exit 1
    fi

    if [ -n "$NOW" ]
    then git co "$NOW"
    fi
}

function drun {
    ( set | grep ^HUBBLE_

      VA=( )
      for v in "${!volume[@]}"; do
          VA+=( --mount "type=bind,source=$(realpath "$v"),destination=$( realpath "${volume[$v]}" )" )
      done

      if [ -n "$AS_USER" ]
      then VA+=( --user "$AS_USER" )
      fi

      cmd=( docker run "${VA[@]}" -ti --rm --name "$CONTAINER_NAME" "$IMAGE_NAME" "$@" )

      ifold <<< "${cmd[*]}"

      if [ -z "$JUST_ECHO" ]
      then "${cmd[@]}" || exit 1
      fi
    )

    return $?
}
