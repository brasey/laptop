# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
. ~/git/bash-git-prompt/gitprompt.sh
alias d='git diff --stat --color'
alias s='git status --short'

function git-pull-all() {
    START=$(git symbolic-ref --short -q HEAD);
    for branch in $(git branch | sed 's/^.//'); do
        git checkout $branch;
        git pull ${1:-origin} $branch || break;
    done;
    git checkout $START;
};

function git-push-all() {
    git push --all ${1:-origin};
};
