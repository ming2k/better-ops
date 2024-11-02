# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

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