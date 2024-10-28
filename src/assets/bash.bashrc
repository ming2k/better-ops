#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything

[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

[[ $DISPLAY ]] && shopt -s checkwinsize

PS1="\[\033[1;34m\]\u\[\033[0m\]@$\[\033[1;33m\]\h\[\033[0m\]:\[\033[1;32m\]\W\[\033[0m\]\\$ "

# Prompt
PS1="\[\033[1;34m\]\u\[\033[0m\]@\[\033[1;33m\]\h\[\033[0m\]:\[\033[1;32m\]\W\[\033[0m\]\\$ "
function bash_prompt {
    history -a
	echo -ne "\033]0;$USER@$(uname -n):$(basename "$PWD")\007\033[ q"
}
PROMPT_COMMAND=bash_prompt

export HISTFILE=~/.bash_history
export HISTSIZE=1000

