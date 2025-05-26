# ~/.bashrc
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Disable terminal flow control (Ctrl-S/Ctrl-Q) to prevent terminal freezing when using key combinations like Ctrl-S in editors like uEmacs
stty -ixon

# Load subconfig
# ---
[ -r "$HOME/.bash/hosts/remote-root.sh" ] && source "$HOME/.bash/hosts/remote-root.sh"

# final validation
# ---
# Make sure histappend is set to avoid overwriting bash history
check_histappend() {
    if shopt -q histappend; then
        return 0
    else
        shopt -s histappend
        return 1
    fi
}
