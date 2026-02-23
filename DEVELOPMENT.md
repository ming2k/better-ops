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
│   ├── get-distribution.sh  # OS detection
│   ├── install-package.sh   # Package manager wrapper (apt/pacman/yum)
│   ├── log.sh               # Logging utilities
│   ├── preflight.sh         # Pre-installation dependencies
│   └── setup/               # Setup modules
│       ├── bash.sh          # Bash configuration (available, not run by default)
│       ├── network.sh       # /etc/hosts setup
│       ├── nvim.sh          # Neovim install + config
│       ├── ssh.sh           # SSH service restart
│       ├── timezone.sh      # Timezone configuration
│       └── zsh.sh           # Zsh install + config
├── config/
│   ├── bash/                # Bash dotfiles (kept for reference)
│   │   ├── .bashrc
│   │   └── .bash/
│   └── zsh/                 # Zsh dotfiles (active)
│       ├── .zshrc
│       └── .zsh/
│           ├── loader.zsh
│           ├── aliases/
│           ├── config/
│           ├── exports/
│           ├── functions/
│           ├── init/
│           ├── prompts/
│           ├── completions/
│           └── scripts/
└── Dockerfile               # Development environment (Debian)
```

## Architecture

### Entry Point — `bin/main.sh`

Parses CLI flags, detects the OS distribution, and sources the appropriate modules.

**Flags:**
- `--user <name>`: exported as `$SETUP_USER`; consumed by setup modules to deploy dotfiles
- `--module <name>`: repeatable; if any `--module` flags are given, only those modules run

**Module guard:**
```bash
module_enabled <name> && . "${PROJECT_ROOT}/lib/setup/<name>.sh"
```

If no `--module` flags are provided, `module_enabled` always returns true (all modules run).

### Setup Modules

Each module in `lib/setup/` follows a two-phase pattern:

1. **System phase** — install packages, configure system-wide settings (always runs)
2. **User phase** — deploy dotfiles, set default shell (runs only when `$SETUP_USER` is set)

```bash
# System phase — always
install_package zsh fzf

# User phase — conditional
if [ -z "${SETUP_USER:-}" ]; then
    log "No --user specified, skipping user configuration"
else
    install_file_for_user "$SETUP_USER" ...
fi
```

### Distribution Support

`get_distribution()` reads `/etc/os-release` and returns a normalized name.
`install_package()` maps to the correct package manager:

| Distribution | Package Manager |
|---|---|
| debian / ubuntu | `apt-get` |
| arch / manjaro | `pacman` |
| centos / rhel / fedora | `yum` |

### Zsh Config Layout

Zsh dotfiles in `config/zsh/.zsh/` are loaded by category via `loader.zsh`:

```
config/     → setopt, stty
exports/    → PATH, EDITOR, FZF_*, XDG_*
aliases/    → ls, grep, fzf shortcuts
functions/  → (user additions)
prompts/    → vcs_info git-aware PROMPT
completions/→ (user additions)
init/       → eval-based tool init (fzf --zsh)
scripts/    → added to PATH
```

## Key Concepts

### Idempotency

All setup scripts must be safe to run multiple times.

1. **File appends** — check before appending:
   ```bash
   if ! grep -q "pattern" "$file"; then
       echo "line" >> "$file"
   fi
   ```

2. **Package installation** — `install_package()` skips already-installed packages automatically.

3. **Version checks** — compare before reinstalling:
   ```bash
   CURRENT=$(/usr/local/bin/nvim --version | awk '{print $2}')
   [ "$CURRENT" = "$TARGET_VERSION" ] && return 0
   ```

4. **Backups** — always take timestamped backups before overwriting:
   ```bash
   backup_file_for_user "$user" ".zshrc"
   ```

### Shared Helpers — `lib/common.sh`

| Function | Description |
|---|---|
| `get_user_home <user>` | Returns home directory (`/root` or `/home/<user>`) |
| `install_file_for_user <user> <src> <dest>` | Copies a file and fixes ownership |
| `install_config_for_user <user> <src> <dest>` | Copies a directory and fixes ownership |
| `backup_file_for_user <user> <relative-path>` | Timestamped backup with 600 permissions |

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
# Full install
./bin/main.sh --user root

# Specific modules only
./bin/main.sh --user root --module zsh --module nvim

# Verify
cat ~/.zshrc
ls -la ~/.zsh/
```

### Security Considerations

- Container runs as root — keep runtime (Podman/Docker) updated
- Use rootless Podman where possible (default for non-root users)
- Only mount necessary directories; avoid mounting sensitive paths
- Don't store credentials in containers or mounted volumes
