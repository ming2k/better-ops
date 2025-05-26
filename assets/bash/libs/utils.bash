# utils.bash - Utility functions for bash configuration

source_file() {
  [ -r "$1" ] && source "$1"
}

source_dir() {
  for file in "$1"/*; do
    [ -r "$file" ] && source "$file"
  done
}

# Check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Safe source - source a file only if it exists
safe_source() {
    [[ -f "$1" ]] && source "$1"
}

# Add to path if directory exists and is not already in path
add_to_path() {
    if [[ -d "$1" && ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}

# Backup a file before modifying it
backup_file() {
    local file="$1"
    local backup="${file}.bak.$(date +%Y%m%d-%H%M%S)"
    
    if [[ -f "$file" ]]; then
        cp "$file" "$backup"
        echo "Backup created: $backup"
    fi
}

# Check if running inside a container
is_container() {
    [[ -f /.dockerenv ]] || grep -q 'container=\|docker\|lxc' /proc/1/environ 2>/dev/null
}

# Get OS information
get_os_info() {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        echo "$NAME $VERSION_ID"
    elif [[ -f /etc/lsb-release ]]; then
        source /etc/lsb-release
        echo "$DISTRIB_ID $DISTRIB_RELEASE"
    elif command_exists sw_vers; then
        echo "macOS $(sw_vers -productVersion)"
    else
        echo "Unknown OS"
    fi
}

# Create directory if it doesn't exist
ensure_dir() {
    [[ -d "$1" ]] || mkdir -p "$1"
}

# Print a horizontal line separator
print_separator() {
    local cols=$(tput cols)
    printf '%*s\n' "${cols}" '' | tr ' ' '-'
}



