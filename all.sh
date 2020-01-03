#!/usr/bin/env bash

V=( 2.7.16
    3.6.10
    3.8.1 )

for i in "${V[@]}"
do PY_V=$i ./build.sh
done
