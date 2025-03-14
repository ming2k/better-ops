#!/bin/bash

print_with_border "SETTING DOCKER ON UBUNTU"

log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') $1"
}

if systemctl list-unit-files sshd.service > /dev/null 2>&1 && sudo systemctl restart sshd.service; then
  log "sshd restarted"
else
  if systemctl list-unit-files sshd.service > /dev/null 2>&1; then
    log "sshd restart failed"
  else
    log "sshd service file does not exist, trying ssh service."
    if systemctl list-unit-files ssh.service > /dev/null 2>&1 && sudo systemctl restart ssh.service; then
      log "ssh restarted"
    else
      if systemctl list-unit-files ssh.service > /dev/null 2>&1; then
        log "ssh restart failed"
      else
        log "ssh service file does not exist."
      fi
    fi
  fi
fi
