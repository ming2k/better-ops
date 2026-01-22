#!/bin/bash

PROJECT_ROOT=$(dirname "$(dirname "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")")")
source $PROJECT_ROOT/lib/common.sh

generate_banner "SETTING TIMEZONE"

# Default timezone (can be overridden by TIMEZONE env var)
TIMEZONE="${TIMEZONE:-Asia/Shanghai}"

# Validate timezone exists
if [ ! -f "/usr/share/zoneinfo/$TIMEZONE" ]; then
    log "error" "Invalid timezone: $TIMEZONE"
    log "info" "List available timezones with: timedatectl list-timezones"
    exit 1
fi

# Get current timezone
CURRENT_TZ=$(timedatectl show --property=Timezone --value 2>/dev/null || cat /etc/timezone 2>/dev/null || echo "unknown")

if [ "$CURRENT_TZ" = "$TIMEZONE" ]; then
    log "Timezone already set to $TIMEZONE"
else
    # Use timedatectl if available (systemd), otherwise use symlink method
    if command -v timedatectl >/dev/null 2>&1 && pidof systemd >/dev/null 2>&1; then
        timedatectl set-timezone "$TIMEZONE"
        log "Set timezone to $TIMEZONE using timedatectl"
    else
        # Fallback for non-systemd systems (containers, etc.)
        ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
        echo "$TIMEZONE" > /etc/timezone
        log "Set timezone to $TIMEZONE using symlink"
    fi
fi

log "Current timezone: $(date +%Z) ($(date +%z))"
