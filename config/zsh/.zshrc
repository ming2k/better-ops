#
# ~/.zshrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Initialize completion system
autoload -Uz compinit && compinit

source ~/.zsh/loader.zsh
