# Set up fzf key bindings and fuzzy completion
if fzf --bash &>/dev/null; then
    eval "$(fzf --bash)"
else
    # Debian/Ubuntu: source from package files
    for f in /usr/share/doc/fzf/examples/key-bindings.bash \
             /usr/share/doc/fzf/examples/completion.bash \
             /usr/share/bash-completion/completions/fzf
    do
        [[ -f "$f" ]] && source "$f"
    done
fi
