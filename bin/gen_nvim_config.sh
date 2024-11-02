#!/bin/bash

# Set the input and output directories
nvim_config_dir="$HOME/.config/nvim"
output_dir="$(dirname "$0")/../assets/nvim_config"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Define the list of files to copy (excluding init.lua)
files=("lua/logger.lua" "lua/utils.lua" "lua/general.lua" "lua/filetype.lua")

# Function to copy file and create parent directories
copy_file() {
    local src="$1"
    local dest="$2"
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
}

# Iterate through the file list and copy files
for file in "${files[@]}"; do
    src_path="$nvim_config_dir/$file"
    dest_path="$output_dir/$file"
    
    if [ -f "$src_path" ]; then
        copy_file "$src_path" "$dest_path"
        echo "Copied: $file"
    else
        echo "Warning: $src_path not found, skipping..."
    fi
done

# Generate init.lua
init_lua_path="$output_dir/init.lua"
echo "-- Generated init.lua" > "$init_lua_path"
echo "" >> "$init_lua_path"

for file in "${files[@]}"; do
    module_name=$(basename "$file" .lua)
    echo "require(\"$module_name\")" >> "$init_lua_path"
done

echo "Generated: init.lua"

echo "Files copied and init.lua generated in: $output_dir"