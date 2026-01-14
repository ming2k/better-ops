#!/bin/bash

# Load all configuration files
for f in ~/.bash/{config,exports,aliases,functions,prompts,completions}/*.{bash,sh}; do
    [[ -r "$f" ]] && source "$f"
done

# Load tool initializations (eval statements run last)
for f in ~/.bash/init/*.{bash,sh}; do
    [[ -r "$f" ]] && source "$f"
done

# Add scripts to PATH
export PATH="$PATH:$HOME/.bash/scripts"
