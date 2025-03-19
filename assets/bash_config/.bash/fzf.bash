# Set up fzf key bindings and fuzzy completion

if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
        source /usr/share/doc/fzf/examples/key-bindings.bash
fi
if [ -f /usr/share/fzf/examples/completion.bash ]; then
        source /usr/share/doc/fzf/examples/completion.bash
fi

alias fzfp="fzf \
        --preview 'fzf-preview.sh {}' \
        --preview-window '~1:+{2}/2:noborder'"

export FZF_DEFAULT_OPTS="--ansi"

# fzf key binding
export FZF_CTRL_T_COMMAND="fd \
        --color=always \
        --hidden \
        --follow \
        --exclude .git"

export FZF_ALT_C_COMMAND="fd --hidden --type d ."
