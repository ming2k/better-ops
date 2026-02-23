#!/usr/bin/env zsh

# Load vcs_info for git-aware prompt
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats ' (%b%u%c)'
zstyle ':vcs_info:git:*' actionformats ' (%b|%a%u%c)'

precmd_functions+=(vcs_info)

# Set color based on user: red for root, green for normal user
if (( EUID == 0 )); then
    _user_color='%F{red}%B'
else
    _user_color='%F{green}%B'
fi

# Git-aware prompt with timestamp
setopt PROMPT_SUBST
PROMPT="${_user_color}%n@%m%b%f:%F{blue}%B%~%b%f%F{yellow}\${vcs_info_msg_0_}%f%F{240} %T%f"$'\n'"$ "

# Set terminal title
precmd_functions+=(set_terminal_title)
set_terminal_title() {
    echo -ne "\033]0;${USER}@$(uname -n):$(basename "$PWD")\007\033[ q"
}
