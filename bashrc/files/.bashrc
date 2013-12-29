# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
. ~/git/bash-git-prompt/bash-git-prompt/gitprompt.sh
alias d='git diff --stat --color'
alias s='git status --short'
