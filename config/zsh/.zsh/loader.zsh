#!/usr/bin/env zsh

# Load all configuration files
for f in ~/.zsh/{config,exports,aliases,functions,prompts,completions}/*.{zsh,sh}(N); do
    source "$f"
done

# Load tool initializations (eval statements run last)
for f in ~/.zsh/init/*.{zsh,sh}(N); do
    source "$f"
done

# Add scripts to PATH
export PATH="$PATH:$HOME/.zsh/scripts"
