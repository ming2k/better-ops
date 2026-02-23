# History file location
export HISTFILE=~/.zsh_history

# History sizes
export HISTSIZE=100000       # Number of commands in memory
export SAVEHIST=200000       # Number of commands saved to file

# History options
setopt HIST_IGNORE_SPACE     # Don't save commands starting with space
setopt HIST_IGNORE_DUPS      # Don't save consecutive duplicate commands
setopt HIST_IGNORE_ALL_DUPS  # Remove older duplicates from history
setopt HIST_SAVE_NO_DUPS     # Don't write duplicates to file
setopt HIST_REDUCE_BLANKS    # Remove superfluous blanks from history
setopt SHARE_HISTORY         # Share history between sessions
setopt INC_APPEND_HISTORY    # Save immediately after each command
setopt EXTENDED_HISTORY      # Save timestamp with each command

# Commands to ignore (won't be saved in history)
export HISTORY_IGNORE="(ls|ll|la|pwd|exit|clear|history|bg|fg|jobs)"
