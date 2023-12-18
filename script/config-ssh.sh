#!/bin/bash

sudo cp $asset_path/sshd_config /etc/ssh/sshd_config

sudo systemctl restart sshd && log "sshd restarted"

log "Finish"
