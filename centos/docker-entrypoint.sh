#!/bin/bash

cat > /usr/bin/get-hubble << EOF
git clone https://github.com/hubblestack/hubble -o github /hubble
git clone https://github.com/hubblestack/hubblestack_data -o github /hubblestack_data
EOF
chmod 0755 /usr/bin/get-hubble

cat > /root/.bashrc << EOF 
export PATH="\$HOME/.pyenv/bin:\$PATH"
eval "\$(pyenv init -)"
PS1='hubble-docker \\w\\$ '
alias ls='ls -h --color=tty'
alias l='ls -sh'
cd /hubble
EOF
source /root/.bashrc
pyenv local $PY_V
pyenv shell $PY_V

echo "entrypoint finished. issuing CMD: $*"
"$@"
