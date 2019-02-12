#!/bin/bash

source "$(dirname "$0")"/include.sh

if [ -z "$NO_VOL" ]; then
    volume[../../adobe/hubble]=/hubble
    volume[../../adobe/hubblestack_data]=/hubblestack_data
fi

dbuild
drun "$@"
dprune
