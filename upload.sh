#!/bin/bash

source "$(dirname "$0")"/include.sh

dprune
dbuild
set -x
docker image push $IMAGE_NAME
