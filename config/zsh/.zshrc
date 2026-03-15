#
# ~/.zshrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Initialize completion system
autoload -Uz compinit && compinit

source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/loader.zsh"
