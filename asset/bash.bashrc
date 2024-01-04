#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything

[ -z "$PS1" ] && return

[[ $DISPLAY ]] && shopt -s checkwinsize

PS1="\[\033[1;34m\]\u\[\033[0m\]@$\[\033[1;33m\]\h\[\033[0m\]:\[\033[1;32m\]\W\[\033[0m\]\\$ "

function bash_prompt {
	echo -ne "\033]0;$USER@$(uname -n):$(basename "$PWD")\007\033[ q"
}

PROMPT_COMMAND=bash_prompt

export EDITOR=vim

alias ls='ls --color=auto'


