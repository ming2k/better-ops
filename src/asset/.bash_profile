export TERM=xterm
export EDITOR=${EDITOR:-/usr/bin/nvim}
export PAGER=${PAGER:-/usr/bin/less}

export ANDROID_HOME=$HOME/Android/Sdk

shopt -s histappend
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="ls:bg:fg:exit"
export HISTTIMEFORMAT="%F %T "
export HISTFILE=$HOME/.bash_history

[ -f ~/.bashrc ] && . ~/.bashrc
