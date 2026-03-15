# Auto-correct minor typos in commands
setopt CORRECT

# Report background job status immediately
setopt NOTIFY

# Disable XON/XOFF flow control to free up C-s and C-q keybindings
# This allows C-s to be used for forward history search
stty -ixon 2>/dev/null
