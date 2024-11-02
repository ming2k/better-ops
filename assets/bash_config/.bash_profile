shopt -s histappend
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="ls:bg:fg:exit"
export HISTTIMEFORMAT="%F %T "
export HISTFILE=$HOME/.bash_history

[ -f ~/.bashrc ] && . ~/.bashrc
