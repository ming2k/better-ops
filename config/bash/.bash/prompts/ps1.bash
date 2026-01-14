#!/bin/bash

# Try to source git-prompt from common locations (distro-agnostic)
for _git_prompt in \
    /usr/share/git/git-prompt.sh \
    /usr/share/git/completion/git-prompt.sh \
    /usr/share/git-core/contrib/completion/git-prompt.sh \
    /usr/lib/git-core/git-sh-prompt \
    /etc/bash_completion.d/git-prompt
do
    [[ -f $_git_prompt ]] && source "$_git_prompt" && break
done
unset _git_prompt

# Set color based on user: red for root, green for normal user
USER_COLOR='\[\033[01;32m\]'
(( EUID == 0 )) && USER_COLOR='\[\033[01;31m\]'

# Git-aware prompt with user-specific color (falls back gracefully if __git_ps1 not available)
if type -t __git_ps1 &>/dev/null; then
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
    PS1="${USER_COLOR}\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]\$(__git_ps1)\[\033[90m\] \t\[\033[00m\]\n\$ "
else
    PS1="${USER_COLOR}\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[90m\] \t\[\033[00m\]\n\$ "
fi

# Set terminal title
PROMPT_COMMAND="echo -ne \"\033]0;$USER@$(uname -n):$(basename "$PWD")\007\033[ q\"; $PROMPT_COMMAND"
