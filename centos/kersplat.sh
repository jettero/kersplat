#!/bin/bash

set +x

export PATH="$PYENV_ROOT/bin:$PATH"
PS1="\u[$PY_V] \w\$ "

alias ls='ls -h --color=tty'
alias l='ls -sh'

eval "$(pyenv init -)"
# pyenv local $PY_V
# pyenv shell $PY_V

# function get-hubble() {
#     git clone https://github.com/hubblestack/hubble -o github /hubble
#     git clone https://github.com/hubblestack/hubblestack_data -o github /hubblestack_data
# }
