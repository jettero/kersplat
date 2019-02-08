#!/bin/bash

source "$(dirname "$0")"/include.sh

volume[$TOP_DIR/../hubble]=/hubble
volume[$TOP_DIR/../hubblestack_data]=/hubblestack_data

dbuild
drun "$@"
dprune
