#!/bin/bash

# if line is replaced, exit status code is 0, or 1. 
replace_line() {
  local file_path=$1
  local search_string=$2
  local replace_string=$3

  local exit_status_code=1

  if [ -f "$file_path" ]; then
    temp_file=$(mktemp)  # 创建临时文件
    while IFS= read -r line; do
      line=$(echo "$line" | sed -e 's/^[[:space:]]*//') # remove the starting space
      if [[ $line == "$search_string"* && $line != \#* ]]; then 
        log "Found a line that needs to be replaced."
        # 将满足条件的行写入临时文件
        echo "$replace_string" >> "$temp_file"
        exit_status_code=0
        continue
      fi
      echo "$line" >> "$temp_file"
    done < "$file_path"

    # 用临时文件替换源文件
    sudo mv "$temp_file" "$file_path";
  fi

  return $exit_status_code
}
