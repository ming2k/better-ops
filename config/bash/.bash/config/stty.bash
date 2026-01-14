# =============================================================================
# Terminal Control Settings (stty)
# =============================================================================

# Disable XON/XOFF flow control to free up C-s and C-q keybindings
# This allows C-s to be used for:
# - Forward search in shells (Ctrl-s)
# - Tmux copy mode search (C-b [ C-s)
# - Vim incremental search
stty -ixon 2>/dev/null
