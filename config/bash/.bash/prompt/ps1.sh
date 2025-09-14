# Set PS1 based on user privileges
if [ "$EUID" -eq 0 ]; then
    # Root prompt with red warning color, grey datetime
    PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[\033[37m\]\t\[\033[00m\]\n\[\033[01;31m\]#\[\033[00m\] '
else
    # Non-root prompt with green color, grey datetime
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[\033[37m\]\t\[\033[00m\]\n\[\033[01;37m\]$\[\033[00m\] '
fi

function prompt_command {
    # -a: Append current session's command history to the history file
    # -c: Clears the current session's command history from memory
    # -r: Reads the history file back into the current session
    # history -a; history -c; history -r;
    echo -ne "\033]0;$USER@$(uname -n):$(basename "$PWD")\007\033[ q";
}
PROMPT_COMMAND=prompt_command


