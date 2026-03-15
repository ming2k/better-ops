#!/bin/bash
set -euo pipefail

#######################################
# Check that required commands are available on the system
# If any command is missing, log an error and return failure
# Arguments:
#   $@ - One or more command names to check
# Returns:
#   0 if all commands are available
#   1 if any command is missing
# Example:
#   require_command zsh fzf git
#######################################
require_command() {
    [ $# -lt 1 ] && { log "error" "Please specify at least one command name."; return 1; }

    local missing=()

    for cmd in "$@"; do
        if command -v "$cmd" >/dev/null 2>&1; then
            log "info" "$cmd is available"
        else
            log "error" "$cmd is not installed. Please install it manually before continuing."
            missing+=("$cmd")
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        log "error" "Missing commands: ${missing[*]}"
        return 1
    fi

    return 0
}
