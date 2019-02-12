#!/bin/bash

source /root/.bashrc

echo "entrypoint finished. issuing CMD: $*"
"$@"
