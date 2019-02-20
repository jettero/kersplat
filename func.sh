#!/bin/bash

function ifold {
    # split super long lines on spaces and indent following rows
    local cmf=$(( COLUMNS - 3 ))
    fold -w $cmf -s | sed -e '2,$s/^/  /'
}
