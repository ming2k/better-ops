# ~/.bashrc
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Disable terminal flow control (Ctrl-S/Ctrl-Q)
stty -ixon

# Load configurations
[ -r "$HOME/.bash/config/history.bash" ] && source "$HOME/.bash/config/history.bash"
[ -r "$HOME/.bash/config/shopt.bash" ] && source "$HOME/.bash/config/shopt.bash"
[ -r "$HOME/.bash/prompt/ps1.sh" ] && source "$HOME/.bash/prompt/ps1.sh"
[ -r "$HOME/.bash/completions/bash-completion-git.sh" ] && source "$HOME/.bash/completions/bash-completion-git.sh"
[ -r "$HOME/.bash/tools/fzf.bash" ] && source "$HOME/.bash/tools/fzf.bash"
