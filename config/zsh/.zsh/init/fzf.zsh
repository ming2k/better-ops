# Set up fzf key bindings and fuzzy completion
if fzf --zsh &>/dev/null; then
    eval "$(fzf --zsh)"
else
    # Debian/Ubuntu: source from package files
    for f in /usr/share/doc/fzf/examples/key-bindings.zsh \
             /usr/share/doc/fzf/examples/completion.zsh
    do
        [[ -f "$f" ]] && source "$f"
    done
fi
