# Development Guide

This guide covers the architecture, development workflow, and testing for better-ops.

## Project Structure

```
better-ops/
├── bin/
│   └── main.sh              # Main entry point
├── lib/
│   ├── banner-generator.sh  # ASCII banner generation
│   ├── common.sh            # Shared functions and variables
│   ├── get-distribution.sh  # OS detection (utility)
│   ├── init.sh              # PROJECT_ROOT initialization
│   ├── install-package.sh   # Command availability checker
│   ├── log.sh               # Logging utilities
│   ├── preflight.sh         # Pre-installation checks
│   └── setup/               # Setup modules
│       ├── bash.sh          # [user]   Bash configuration
│       ├── zsh.sh           # [user]   Zsh configuration
│       ├── nvim.sh          # [user]   Neovim config deployment
│       ├── ssh.sh           # [system] SSH service restart
│       ├── network.sh       # [system] /etc/hosts setup
│       └── timezone.sh      # [system] Timezone configuration
├── config/
│   ├── shared/              # Shell-agnostic config (aliases, exports, etc.)
│   │   ├── aliases/
│   │   ├── exports/
│   │   ├── functions/
│   │   └── scripts/
│   ├── bash/                # Bash-specific dotfiles
│   │   ├── .bashrc
│   │   └── .bash/
│   │       ├── loader.bash
│   │       ├── config/      # shopt, stty, history
│   │       ├── init/        # fzf --bash
│   │       └── prompts/     # PS1
│   ├── zsh/                 # Zsh-specific dotfiles
│   │   ├── .zshrc
│   │   └── .zsh/
│   │       ├── loader.zsh
│   │       ├── config/      # setopt, keybindings, history
│   │       ├── init/        # fzf --zsh
│   │       └── prompts/     # PROMPT
│   └── nvim/                # Neovim configuration
├── tests/                   # Test suite
└── Dockerfile               # Development environment (Debian)
```

## Architecture

### Entry Point — `bin/main.sh`

```bash
# Auto-detect shell, run user-level modules only (default)
./bin/main.sh

# Also run system-level modules (ssh, network, timezone)
./bin/main.sh --system

# Run specific modules only (any level)
./bin/main.sh zsh nvim
./bin/main.sh ssh

# Help
./bin/main.sh --help
```

Without arguments, `main.sh` auto-detects `bash` or `zsh` from `$SHELL` and runs
user-level modules only (detected shell + nvim).

With `--system`, system-level modules (ssh, network, timezone) are also included.

Specifying modules by name runs exactly those modules regardless of level.

### Module Levels

Modules are classified into two levels for safety:

| Level | Modules | Behavior | Requires sudo |
|-------|---------|----------|---------------|
| **User** | bash, zsh, nvim | Only modifies `$HOME`, runs by default | No |
| **System** | ssh, network, timezone | Modifies system config, requires `--system` or explicit name | Yes |

### Setup Modules

Each module in `lib/setup/` follows the same pattern:

1. Source `lib/common.sh` (logging, helpers)
2. Call `require_command` to check dependencies — fails early if missing
3. Deploy configuration to the current user's `$HOME`

All modules install for the current user only. No multi-user support.

### Dependency Checking

Modules do **not** install packages. They check that required commands exist
and fail with a clear message if anything is missing:

```bash
require_command zsh fzf   # exits with error listing missing commands
```

### XDG Base Directory Layout

All configuration follows the XDG specification. Deployed layout:

```
~/
├── .bashrc / .zshrc              # Thin rc files, source the loader
├── .config/                      # XDG_CONFIG_HOME
│   ├── shell-shared/             # Shared aliases, exports, functions, scripts
│   ├── bash/                     # Bash-specific config
│   └── zsh/                      # Zsh-specific config
└── .local/share/                 # XDG_DATA_HOME
    ├── bash/history
    └── zsh/history
```

Loaders resolve paths via `${XDG_CONFIG_HOME:-$HOME/.config}` so custom
`XDG_CONFIG_HOME` values are respected.

### Config Loading Order

Both shells follow the same loading order in their loader:

1. **Shared config** — `~/.config/shell-shared/{exports,aliases,functions}/*.sh`
2. **Shell-specific config** — `~/.config/{bash,zsh}/{config,exports,aliases,...}/*.{bash,sh}` or `*.{zsh,sh}`
3. **Tool init** — `~/.config/{bash,zsh}/init/*` (eval-based, loaded last)
4. **Scripts to PATH** — both `shell-shared/scripts` and shell-specific `scripts/`

### Shared vs Shell-Specific

| Shared (`config/shared/`) | Shell-specific |
|---|---|
| Aliases (ls, grep, fzf) | History config (shopt vs setopt) |
| Exports (PATH, EDITOR, FZF_*, XDG_*) | Prompt (PS1 vs PROMPT) |
| Functions | Shell options (shopt vs setopt) |
| Scripts | Keybindings |
| | Tool init (fzf --bash vs fzf --zsh) |

## Key Concepts

### Idempotency

All setup scripts are safe to run multiple times:

- **File appends** — check before appending:
  ```bash
  if ! grep -q "pattern" "$file"; then
      echo "line" >> "$file"
  fi
  ```
- **Backups** — timestamped backups before overwriting:
  ```bash
  backup_file ".zshrc"
  ```

### Shared Helpers — `lib/common.sh`

| Function | Description |
|---|---|
| `backup_file <relative-path>` | Timestamped backup of `$HOME/<path>` |
| `install_file <src> <dest>` | Copy file to `$HOME/<dest>` |
| `install_config <src> <dest>` | Copy directory to `$HOME/<dest>` |
| `create_config_dir` | Ensure `~/.config/better-ops/` exists |
| `is_container` | Check if running inside Docker/Podman |

### Logging

```bash
log "info message"            # [INFO] with timestamp
log "warn" "warning message"  # [WARN] in yellow
log "error" "error message"   # [ERROR] in red
```

## Development Workflow

### Container Environment

Use containers to test against a clean Debian image without affecting your host.

```bash
# Build
podman build -t better-ops:dev .

# Run (live-mounts repo)
podman run -it --name better-ops-dev -v ./:/better-ops better-ops:dev

# Re-enter existing container
podman start -ai better-ops-dev

# Clean up
podman rm better-ops-dev
```

Inside the container:
```bash
# User-level only (auto-detects shell)
./bin/main.sh

# Include system-level modules
./bin/main.sh --system

# Specific modules only
./bin/main.sh zsh nvim

# Verify
cat ~/.zshrc
ls -la ~/.config/zsh/
```

### Security Considerations

- System-level modules are opt-in (`--system`) to prevent accidental system changes
- Container runs as root — keep runtime (Podman/Docker) updated
- Use rootless Podman where possible (default for non-root users)
- Only mount necessary directories; avoid mounting sensitive paths
- Don't store credentials in containers or mounted volumes
