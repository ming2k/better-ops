# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2026-03-15

### Changed

#### Architecture
- **Module levels**: Modules are now classified as user-level or system-level
  - User-level (bash, zsh, nvim): only modifies `$HOME`, runs by default
  - System-level (ssh, network, timezone): requires `--system` flag or explicit module name
- **XDG compliance**: All config deployed to `~/.config/` (XDG_CONFIG_HOME), history files to `~/.local/share/` (XDG_DATA_HOME)
- **Shared config layer**: Shell-agnostic aliases, exports, functions, and scripts live in `config/shared/`, deployed to `~/.config/shell-shared/`
- **No auto-install**: Modules check for required commands with `require_command` instead of installing packages; users install dependencies manually
- **Current user only**: Removed `--user` flag and multi-user support; all modules install for the current user
- **Shell auto-detection**: `main.sh` auto-detects bash/zsh from `$SHELL`; modules can also be specified explicitly

#### Entry Point
- Rewrote `bin/main.sh` with `--system` flag and explicit module selection
- Removed legacy distribution-specific script sourcing

#### Config Structure
- Moved shared config (aliases, exports, paths, xdg, fzf, defaults) from duplicated bash/zsh files into `config/shared/`
- Loaders (`loader.bash`, `loader.zsh`) now source shared config first, then shell-specific config
- History files use XDG_DATA_HOME (`~/.local/share/{bash,zsh}/history`)
- Added full XDG variable exports (XDG_CONFIG_HOME, XDG_DATA_HOME, XDG_STATE_HOME, XDG_CACHE_HOME)

#### Setup Modules
- Simplified `lib/common.sh`: removed multi-user helpers, replaced with `install_file`, `install_config`, `backup_file` operating on `$HOME`
- Shell modules use `chsh` instead of `usermod` for setting default shell
- Neovim module only deploys config (removed appimage download/verify logic)
- All modules source `lib/common.sh` consistently

### Removed
- `lib/install_package.sh` (legacy, replaced by `lib/install-package.sh` with `require_command`)
- `lib/get_distribution.sh` (duplicate of `lib/get-distribution.sh`)
- `lib/generate_banner.sh` (superseded by `lib/banner-generator.sh`)
- `install_package()` function and all distribution-specific package installation logic
- Multi-user functions: `get_user_home()`, `get_target_users()`, `for_each_target_user()`, `*_for_user()` variants
- `get_system_info()` (unused)
- `SETUP_USER` environment variable and `--user` CLI flag

## [1.1.0] - 2025-12-29

### Changed

#### Development Environment
- Simplified Dockerfile to minimal base (only Debian Trixie Slim + WORKDIR)
- Removed pre-installed packages from container - all tools now installed via scripts
- Updated container workflow to run as root by default
- Removed `--userns=keep-id` requirement for simpler development setup
- Removed dev-container.sh helper script in favor of direct podman commands
- Container now persists by default with `--name better-ops-dev` (removed `--rm` flag)

#### Installation Scripts
- Added bash and sudo to preflight package installation
- Fixed nvim.sh to use sudo when writing to /usr/local/bin
- Added fuse3 to preflight for AppImage support
- Improved bash.sh to set bash as default shell for current user and new users
- Added automatic shell reload with `exec bash` after bash configuration

#### Documentation
- Restructured DEVELOPMENT.md with "Development Workflow" section
- Updated container usage instructions with clearer commands
- Added container re-entry and removal instructions
- Simplified Dockerfile architecture documentation
- Removed references to removed dev-container.sh script

#### Core Scripts
- Fixed shell validation in main.sh to check BASH_VERSION instead of SHELL variable
- Changed shell validation message from WARN to ERROR for clarity

### Removed
- SELinux `:Z` volume flag (unnecessary for Arch Linux and most setups)
- dev-container.sh script (replaced with direct documentation)
- Pre-installed packages from Dockerfile (git, curl, wget, bash)
- Passwordless sudo configuration from Dockerfile
- Default CMD from Dockerfile (uses base image default)

## [1.0.0] - 2025-09-14

### Added

#### Core System
- Automated installation script with OS detection (Debian 12, Ubuntu)
- Modular library system with logging, utilities, and preflight checks
- Container-based testing environment with Docker/Podman support

#### Bash Environment
- Advanced bash configuration with colored prompts (grey datetime)
- Comprehensive aliases, functions, and completions
- Integrated tools: FZF, GPG, NNN file manager
- Multi-environment support (personal, root, remote)

#### Neovim Setup
- Complete Lua-based configuration with LSP support
- 15+ language-specific configurations
- Plugin ecosystem: LuaSnip, nvim-cmp, Telescope, Treesitter
- Customizable themes and intelligent folding

#### Security & SSH
- Hardened SSH daemon configuration
- Secure client/server setup scripts
