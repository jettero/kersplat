#!/bin/bash

echo "/docker-entrypoint.sh"

source /etc/profile.d/kersplat.sh

exec "$@"
