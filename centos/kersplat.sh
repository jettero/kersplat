#!/bin/bash

echo "/etc/profile.d/kersplat.sh"

export PATH="$PYENV_ROOT/bin:$PATH"
PS1="\u[$PY_V] \w\$ "

alias ls='ls -h --color=tty'
alias l='ls -sh'

eval "$(pyenv init -)"
