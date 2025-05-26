install_package() {
    # Validate input
    [ $# -lt 1 ] && { log "error" "Please specify at least one package name."; return 1; }
    
    # Determine privilege escalation method
    if [ "$EUID" -eq 0 ]; then
        SUDO_CMD=""
    elif command -v sudo >/dev/null 2>&1; then
        SUDO_CMD="sudo"
    else
        log "error" "Elevated privileges required. Run as root or install 'sudo'."
        return 1
    fi
    
    # Package manager configuration
    case "$DIST_OS" in
        ubuntu|debian)
            PM="apt-get"
            UPDATE_CMD="update"
            INSTALL_CMD="install -y"
            CHECK_CMD() { dpkg -l 2>/dev/null | grep -q "^ii  $1 "; }
            ;;
        centos|rhel|fedora)
            PM="yum"
            UPDATE_CMD="makecache"
            INSTALL_CMD="install -y"
            CHECK_CMD() { rpm -q "$1" >/dev/null 2>&1; }
            ;;
        arch|manjaro)
            PM="pacman"
            UPDATE_CMD="-Syyu --noconfirm"
            INSTALL_CMD="-S --noconfirm"
            CHECK_CMD() { pacman -Qi "$1" >/dev/null 2>&1; }
            ;;
        *)
            log "error" "Unsupported distribution: $DIST_OS"
            return 1
            ;;
    esac
    
    # Update package repository once
    log "Updating package repository..."
    if ! $SUDO_CMD $PM $UPDATE_CMD >/dev/null 2>&1; then
        log "error" "Failed to update package repository"
        return 1
    fi
    
    # Process packages
    local installed=0 skipped=0 failed=0
    
    for package in "$@"; do
        if CHECK_CMD "$package"; then
            log "info" "$package already installed"
            ((skipped++))
        else
            log "info" "Installing $package..."
            if $SUDO_CMD $PM $INSTALL_CMD "$package" >/dev/null 2>&1; then
                log "success" "$package installed successfully"
                ((installed++))
            else
                log "error" "Failed to install $package"
                ((failed++))
            fi
        fi
    done
    
    # Summary
    log "info" "Summary: $installed installed, $skipped already present, $failed failed"
    [ $failed -eq 0 ] && return 0 || return 1
}
