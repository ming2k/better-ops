USER_COLOR="\[\033[01;31m\]"
TITLE_PREFIX="ROOT"

PS1='\
'"$USER_COLOR"'\u@\h\
\[\033[00m\]:\
\[\033[01;34m\]\w\
\[\033[33m\]$(__git_ps1)\
\[\033[00m\]\n\$ '

function prompt_command {
    # Append current session's command history to the history file 
    history -a;
    # -c: Clears the current session's command history from memory
    # -r: Reads the history file back into the current session
    # history -a; history -c; history -r;
    echo -ne "\033]0;$TITLE_PREFIX@$(uname -n):$(basename "$PWD")\007\033[ q";
}
PROMPT_COMMAND=prompt_command


