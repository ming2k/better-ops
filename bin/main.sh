#!/bin/bash
set -euo pipefail

# Check if running with bash
if [ -z "$BASH_VERSION" ]; then
    echo -e "[$(date "+%Y-%m-%d %H:%M:%S")] [\e[31mERROR\e[0m] This script requires bash"
    exit 1
fi

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "[$(date "+%Y-%m-%d %H:%M:%S")] [\e[31mERROR\e[0m] This script must be run as root (use sudo)"
    exit 1
fi

# Initialize project root and environment
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
source "$SCRIPT_DIR/../lib/init.sh"

source "$PROJECT_ROOT/lib/banner-generator.sh"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/get-distribution.sh"

# Parse arguments
export SETUP_USER=""
SETUP_MODULES=()
while [[ $# -gt 0 ]]; do
    case "$1" in
        --user)
            SETUP_USER="$2"
            shift 2
            ;;
        --module)
            SETUP_MODULES+=("$2")
            shift 2
            ;;
        *)
            log "warn" "Unknown argument: $1"
            shift
            ;;
    esac
done

# Returns 0 if the given module should run.
# If no --module flags were given, all modules run.
module_enabled() {
    local module="$1"
    [[ ${#SETUP_MODULES[@]} -eq 0 ]] && return 0
    for m in "${SETUP_MODULES[@]}"; do
        [[ "$m" == "$module" ]] && return 0
    done
    return 1
}

# Get distribution
DIST_OS=$(get_distribution)
SCRIPT_DIR="$PROJECT_ROOT/scripts"

# Print run summary
_modules_display="${SETUP_MODULES[*]:-all}"
_user_display="${SETUP_USER:-none}"
log "Distribution : $DIST_OS"
log "User         : $_user_display"
log "Modules      : $_modules_display"
unset _modules_display _user_display

# Preflight check
# -------------------
. "${PROJECT_ROOT}/lib/preflight.sh"

# Scripts
# ---------------------
if [ "$DIST_OS" = "debian" ]; then
    module_enabled timezone && . "${PROJECT_ROOT}/lib/setup/timezone.sh"
    module_enabled network  && . "${PROJECT_ROOT}/lib/setup/network.sh"
    module_enabled ssh      && . "${PROJECT_ROOT}/lib/setup/ssh.sh"
    module_enabled zsh      && . "${PROJECT_ROOT}/lib/setup/zsh.sh"
    module_enabled nvim     && . "${PROJECT_ROOT}/lib/setup/nvim.sh"
fi

if [ "$DIST_OS" = "ubuntu" ]; then
    module_enabled timezone && . "${PROJECT_ROOT}/lib/setup/timezone.sh"
    module_enabled network  && . "${PROJECT_ROOT}/lib/setup/network.sh"
    module_enabled zsh      && . "${PROJECT_ROOT}/lib/setup/zsh.sh"
    module_enabled ssh      && . "${PROJECT_ROOT}/lib/setup/ssh.sh"
    module_enabled nvim     && . "${PROJECT_ROOT}/lib/setup/nvim.sh"
fi

if [ "$DIST_OS" = "arch" ]; then
    module_enabled timezone && . "${PROJECT_ROOT}/lib/setup/timezone.sh"
    module_enabled network  && . "${PROJECT_ROOT}/lib/setup/network.sh"
    module_enabled ssh      && . "${PROJECT_ROOT}/lib/setup/ssh.sh"
    module_enabled zsh      && . "${PROJECT_ROOT}/lib/setup/zsh.sh"
    module_enabled nvim     && . "${PROJECT_ROOT}/lib/setup/nvim.sh"
fi
