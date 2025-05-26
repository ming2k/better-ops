# colors.bash - Terminal color definitions and color utility functions

# Reset
export COLOR_RESET="\033[0m"

# Regular Colors
export COLOR_BLACK="\033[0;30m"
export COLOR_RED="\033[0;31m"
export COLOR_GREEN="\033[0;32m"
export COLOR_YELLOW="\033[0;33m"
export COLOR_BLUE="\033[0;34m"
export COLOR_PURPLE="\033[0;35m"
export COLOR_CYAN="\033[0;36m"
export COLOR_WHITE="\033[0;37m"

# Bold
export COLOR_BOLD_BLACK="\033[1;30m"
export COLOR_BOLD_RED="\033[1;31m"
export COLOR_BOLD_GREEN="\033[1;32m"
export COLOR_BOLD_YELLOW="\033[1;33m"
export COLOR_BOLD_BLUE="\033[1;34m"
export COLOR_BOLD_PURPLE="\033[1;35m"
export COLOR_BOLD_CYAN="\033[1;36m"
export COLOR_BOLD_WHITE="\033[1;37m"

# Underline
export COLOR_UNDERLINE_BLACK="\033[4;30m"
export COLOR_UNDERLINE_RED="\033[4;31m"
export COLOR_UNDERLINE_GREEN="\033[4;32m"
export COLOR_UNDERLINE_YELLOW="\033[4;33m"
export COLOR_UNDERLINE_BLUE="\033[4;34m"
export COLOR_UNDERLINE_PURPLE="\033[4;35m"
export COLOR_UNDERLINE_CYAN="\033[4;36m"
export COLOR_UNDERLINE_WHITE="\033[4;37m"

# Background
export COLOR_BG_BLACK="\033[40m"
export COLOR_BG_RED="\033[41m"
export COLOR_BG_GREEN="\033[42m"
export COLOR_BG_YELLOW="\033[43m"
export COLOR_BG_BLUE="\033[44m"
export COLOR_BG_PURPLE="\033[45m"
export COLOR_BG_CYAN="\033[46m"
export COLOR_BG_WHITE="\033[47m"

# Print colored text
# Usage: print_color "text" "$COLOR_RED"
print_color() {
    local text="$1"
    local color="$2"
    echo -e "${color}${text}${COLOR_RESET}"
}

# Check if terminal supports colors
has_colors() {
    local num_colors=$(tput colors 2>/dev/null)
    [[ -n "$num_colors" && "$num_colors" -ge 8 ]]
}

# Disable colors if not supported or if in a pipe
if ! has_colors || [[ ! -t 1 ]]; then
    # If colors not supported, make them no-ops
    COLOR_RESET=""
    COLOR_BLACK=""
    COLOR_RED=""
    COLOR_GREEN=""
    COLOR_YELLOW=""
    COLOR_BLUE=""
    COLOR_PURPLE=""
    COLOR_CYAN=""
    COLOR_WHITE=""
    # And so on for all color variables...
fi

# Print success message
print_success() {
    print_color "[SUCCESS] $1" "$COLOR_GREEN"
}

# Print error message
print_error() {
    print_color "[ERROR] $1" "$COLOR_RED" >&2
}

# Print warning message
print_warning() {
    print_color "[WARNING] $1" "$COLOR_YELLOW"
}

# Print info message
print_info() {
    print_color "[INFO] $1" "$COLOR_CYAN"
}

