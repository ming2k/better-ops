alias fars='curl -F "c=@-" "http://fars.ee/"'
alias irssi='irssi --home=~/.config/irssi'

# Execute this command in two or more different sessions to sync their command history
alias sync-hist="history -a; history -c; history -r"
alias squote='sed "s/.*/\"\0\"/"'
# alias m2k-llm="xargs -I {} llama-cli -m ~/ai-models/DeepSeek-R1-Distill-Llama-8B.gguf -p {} -n 512 -no-cnv 2>/dev/null"

# Flatpak
alias code='flatpak run com.visualstudio.code'
alias typora='flatpak run io.typora.Typora'

alias docker="podman"

