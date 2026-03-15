#!/bin/bash
set -euo pipefail

PROJECT_ROOT=$(dirname "$(dirname "$(readlink -f "$0")")")
source "$PROJECT_ROOT/lib/init.sh"
source "$PROJECT_ROOT/lib/log.sh"

# Module classification
USER_MODULES=(bash zsh nvim)
SYSTEM_MODULES=(ssh network timezone)

usage() {
    cat << 'EOF'
Usage: main.sh [options] [module ...]

Options:
  --system    Also run system-level modules (ssh, network, timezone)
  -h, --help  Show this help message

User-level modules (safe, only modifies $HOME):
  bash        Configure bash shell
  zsh         Configure zsh shell
  nvim        Configure Neovim

System-level modules (modifies system config, may require sudo):
  ssh         Restart SSH service
  network     Configure /etc/hosts
  timezone    Set system timezone

If no module is specified, auto-detects your shell and runs all
user-level modules. Add --system to include system-level modules.

Specifying a module by name always runs it regardless of level.

Examples:
  main.sh                # auto-detect shell + user-level modules
  main.sh --system       # auto-detect shell + all modules
  main.sh zsh nvim       # only configure zsh and nvim
  main.sh ssh            # only restart ssh (explicit is always allowed)
EOF
}

run_module() {
    local module="$1"
    local script="$PROJECT_ROOT/lib/setup/${module}.sh"
    if [ -f "$script" ]; then
        source "$script"
    else
        log "error" "Unknown module: $module"
        return 1
    fi
}

# Parse arguments
include_system=false
modules=()

for arg in "$@"; do
    case "$arg" in
        -h|--help)
            usage
            exit 0
            ;;
        --system)
            include_system=true
            ;;
        *)
            modules+=("$arg")
            ;;
    esac
done

if [ ${#modules[@]} -gt 0 ]; then
    # Explicit modules: run exactly what was requested
    for module in "${modules[@]}"; do
        run_module "$module"
    done
else
    # Auto-detect shell
    current_shell=$(basename "$SHELL")
    case "$current_shell" in
        zsh)  shell_module="zsh" ;;
        bash) shell_module="bash" ;;
        *)
            log "error" "Unsupported shell: $current_shell. Please specify a module explicitly."
            usage
            exit 1
            ;;
    esac

    log "info" "Auto-detected shell: $current_shell"

    # Run user-level modules: detected shell + non-shell user modules
    run_module "$shell_module"
    run_module nvim

    # System-level modules only with --system
    if [ "$include_system" = true ]; then
        log "info" "Running system-level modules"
        for module in "${SYSTEM_MODULES[@]}"; do
            run_module "$module"
        done
    fi
fi
