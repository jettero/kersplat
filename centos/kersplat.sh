#!/bin/bash

export PY_V=$(< /etc/PY_V)
export PATH="$PYENV_ROOT/bin:$PATH"
export PS1="\u[\$(pyenv version-name)] \w\$ "

alias ls='ls -h --color=tty'
alias l='ls -sh'

set -o vi

eval "$(pyenv init -)"

echo "/etc/profile.d/kersplat.sh PV_V=$(pyenv version-name)"
