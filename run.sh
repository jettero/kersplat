#!/bin/bash

source "$(dirname "$0")"/include.sh

volume[../../adobe/hubble]=/hubble
volume[../../adobe/hubblestack_data]=/hubblestack_data

dbuild
drun "$@"
dprune
