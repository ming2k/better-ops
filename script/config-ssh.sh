#!/bin/bash

print_with_border "CONFIG SSH"

sshd_config_path="/etc/ssh/sshd_config"

replace_line $sshd_config_path "PasswordAuthentication" "PasswordAuthentication no" || sudo echo "PasswordAuthentication no" >> $sshd_config_path
replace_line $sshd_config_path "PermitRootLogin" "PermitRootLogin yes" || sudo echo "PermitRootLogin yes" >> $sshd_config_path

replace_line $sshd_config_path "ClientAliveInterval" "ClientAliveInterval 120" || sudo echo "ClientAliveInterval 120" >> $sshd_config_path
replace_line $sshd_config_path "ClientAliveCountMax" "ClientAliveCountMax 2" || sudo echo "ClientAliveCountMax 2" >> $sshd_config_path

sudo systemctl restart sshd && log "sshd restarted"

log "Finish"
