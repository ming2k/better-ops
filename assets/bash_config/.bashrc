# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

shopt -s histappend
shopt -s cdspell

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias code='code --ozone-platform=$XDG_SESSION_TYPE'
alias less='less -S +G'
# Open the command manual in browser by default
# alias man="man -Hgoogle-chrome-stable"
#alias man="man -Hfirefox"
#unset BROWSER

# Terminal Prompt Setting
PS1="\[\033[1;34m\]\u\[\033[0m\]@\[\033[1;33m\]\h\[\033[0m\]:\[\033[1;32m\]\W\[\033[0m\]\\$ "
function prompt_command {
    history -a; history -c; history -r;
    echo -ne "\033]0;$USER@$(uname -n):$(basename "$PWD")\007\033[ q";
}
PROMPT_COMMAND=prompt_command



