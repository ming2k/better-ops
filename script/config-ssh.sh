#!/bin/bash

enable_ssh_feature() {
    local file_path=/etc/ssh/sshd_config
    local key=$1
    local target_value=$2

    local enabled=0

    # create a temp file
    temp_file=$(mktemp)  
    while IFS= read -r line; do
        line=$(echo "$line" | sed -e 's/^[[:space:]]*//') # remove the starting space
        if [[ $line == "$key"* && $line != \#* ]]; then 
            # 将满足条件的行写入临时文件
            echo "$key $target_value" >> "$file_path"
            log "\"$key\" has been replaced."
            enabled=1
            continue
        fi
        echo "$line" >> "$temp_file"
    done < "$file_path"

    [ $enabled -eq 1] || echo "$key $target_value" >> "$file_path" && log "\"$key\" has been inserted."

}

print_with_border "CONFIG SSH"

sshd_config_path="/etc/ssh/sshd_config"

enable_ssh_feature "PasswordAuthentication" "no"
enable_ssh_feature "PermitRootLogin" "yes"

enable_ssh_feature "ClientAliveInterval" "120"
enable_ssh_feature "ClientAliveCountMax" "2"

sudo systemctl restart sshd && log "sshd restarted"

log "Finish"
