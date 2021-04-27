#!/bin/bash

source "$(dirname "$0")"/include.sh

dprune
dbuild
set -x
docker image push $IMAGE_NAME

# NOTE TO SELF:
# docker image tag jettero/kersplat:centos-v1.0.18 hubblestack/jenkins:centos-v1.0.18
# docker image push hubblestack/jenkins:centos-v1.0.18
