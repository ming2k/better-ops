for file in $HOME/.bash/libs/*; do
  [ -r "$file" ] && source "$file"
done

# Foreign Scripts
source_dir $HOME/.bash/plugins

# Bash Platform
source_file $HOME/.bash/prompt/nonroot-ps.sh

source_dir $HOME/.bash/exports
source_dir $HOME/.bash/options
source_dir $HOME/.bash/aliases
source_dir $HOME/.bash/completions
source_dir $HOME/.bash/functions
source_dir $HOME/.bash/tools

