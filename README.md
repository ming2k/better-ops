# Better Operations

All operations serve better VPS management, committed to simplicity and efficiency.

## Features

- Zsh Configuration: Custom aliases, functions, completions, git-aware prompt, fzf integration
- Neovim Setup: Complete configuration with plugins and language support
- SSH Configuration: Secure SSH daemon and client setup

## Supported Distributions

| Distribution | Status |
|--------------|--------|
| Debian 12    | Passed |
| Debian 13    | Passed |
| Ubuntu 24.04 | Passed |
| Arch Linux   | Passed |

## Quick Start

Clone the project:

```bash
# Debian/Ubuntu
apt install git sudo

# Arch
pacman -S git sudo

# Clone repository
git clone https://github.com/ming2k/better-ops.git && cd better-ops
```

Install:

```bash
# Run complete setup (packages only, no user config)
sudo ./bin/main.sh

# Run with user config
sudo ./bin/main.sh --user <username>

# Run specific modules only
sudo ./bin/main.sh --user root --module zsh --module nvim
```

## CLI Reference

```
./bin/main.sh [--user <username>] [--module <name>] ...
```

| Flag | Description |
|------|-------------|
| `--user <username>` | User to install dotfiles and shell config for. If omitted, all user-level steps are skipped. |
| `--module <name>` | Run only the named module(s). Can be repeated. If omitted, all modules run. |

**Available modules:** `timezone`, `network`, `ssh`, `zsh`, `nvim`

### Examples

```bash
# Full setup for user "alice"
sudo ./bin/main.sh --user alice

# Only configure zsh and nvim for root (e.g. on Arch)
sudo ./bin/main.sh --user root --module zsh --module nvim

# Install all packages system-wide, skip dotfiles
sudo ./bin/main.sh

# Override timezone
TIMEZONE="America/New_York" sudo ./bin/main.sh --user alice
```

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `TIMEZONE` | `Asia/Shanghai` | System timezone |

**Note:** Neovim version (v0.11.1) is hardcoded for stability. To change it, edit `lib/setup/nvim.sh` directly.

## Testing

### Unit Tests

```bash
./tests/run-tests.sh
```

### Code Quality (ShellCheck)

```bash
./scripts/lint.sh
```

Install ShellCheck if needed:
```bash
# Debian/Ubuntu
sudo apt-get install shellcheck

# Arch
sudo pacman -S shellcheck
```

### Integration Tests

```bash
./tests/integration/test-full-install.sh
```

Requires Podman or Docker.

## Troubleshooting

1. Run tests: `./tests/run-tests.sh`
2. Enable debug mode: `bash -x ./bin/main.sh`
3. Verify in a clean container: `./tests/integration/test-full-install.sh`

Common issues:

- **Package installation fails**: Check internet connection and disk space
- **Neovim download fails**: Verify internet access to GitHub
- **Checksum verification fails**: Retry download or check checksum in `lib/setup/nvim.sh`
- **Permission denied**: Run with `sudo`

## Security

- All downloads verified with SHA256 checksums
- Backup files have restrictive permissions (600)
- Proper error handling with `set -euo pipefail`
- All variable expansions are properly quoted

## Development

See [DEVELOPMENT.md](DEVELOPMENT.md) for architecture, workflow, and contributing.
