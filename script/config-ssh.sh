#!/bin/bash

enable_ssh_feature() {
    local file_path=/etc/ssh/sshd_config
    local key=$1
    local target_value=$2

    # create a temp file
    temp_file=$(mktemp)  
    while IFS= read -r line; do
        line=$(echo "$line" | sed -e 's/^[[:space:]]*//') # remove the starting space
        if [[ $line == "$key"* && $line != \#* ]]; then 
            log "\"$key\" has been replaced."
            # 将满足条件的行写入临时文件
            echo "$key $target_value" >> "$temp_file"
            continue
        else
            log "\"$key\" has been inserted."
            echo "$key $target_value" >> "$temp_file"
        fi
        echo "$line" >> "$temp_file"
    done < "$file_path"

    # 用临时文件替换源文件
    sudo mv "$temp_file" "$file_path";
}

print_with_border "CONFIG SSH"

sshd_config_path="/etc/ssh/sshd_config"

enable_ssh_feature "PasswordAuthentication" "no"
enable_ssh_feature "PermitRootLogin" "yes"

enable_ssh_feature "ClientAliveInterval" "120"
enable_ssh_feature "ClientAliveCountMax" "2"

sudo systemctl restart sshd && log "sshd restarted"

log "Finish"
