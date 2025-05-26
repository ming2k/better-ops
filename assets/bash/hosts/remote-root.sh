for file in $HOME/.bash/libs/*; do
  [ -r "$file" ] && source "$file"
done

# Bash Platform
source_file $HOME/.bash/prompt/root-ps.sh

source_dir $HOME/.bash/exports
source_dir $HOME/.bash/options

# Aliases
# ---
source_file $HOME/.bash/aliases/basic-command.sh

source_dir $HOME/.bash/completions
source_dir $HOME/.bash/functions

