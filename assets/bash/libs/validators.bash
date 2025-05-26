# validators.bash - Input validation functions for bash scripts

# Check if a string is empty
is_empty() {
    [[ -z "$1" ]]
}

# Check if a string is not empty
is_not_empty() {
    [[ -n "$1" ]]
}

# Check if input is a valid integer
is_integer() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

# Check if input is a valid number (integer or float)
is_number() {
    [[ "$1" =~ ^[0-9]+(\.[0-9]+)?$ ]]
}

# Check if input is within a range (inclusive)
in_range() {
    local value="$1"
    local min="$2"
    local max="$3"
    
    if ! is_number "$value" || ! is_number "$min" || ! is_number "$max"; then
        return 1
    fi
    
    (( $(echo "$value >= $min && $value <= $max" | bc -l) ))
}

# Check if a string has at least N characters
has_min_length() {
    local str="$1"
    local min_len="$2"
    
    [[ ${#str} -ge $min_len ]]
}

# Check if a string doesn't exceed N characters
has_max_length() {
    local str="$1"
    local max_len="$2"
    
    [[ ${#str} -le $max_len ]]
}

# Check if a string contains only alphanumeric characters
is_alphanumeric() {
    [[ "$1" =~ ^[a-zA-Z0-9]+$ ]]
}

# Check if a string matches a regular expression
matches_regex() {
    local str="$1"
    local regex="$2"
    
    [[ "$str" =~ $regex ]]
}

# Check if a file exists and is readable
is_readable_file() {
    [[ -f "$1" && -r "$1" ]]
}

# Check if a directory exists and is writable
is_writable_dir() {
    [[ -d "$1" && -w "$1" ]]
}

# Check if a string is a valid IP address
is_valid_ip() {
    local ip="$1"
    local regex='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
    
    if [[ ! $ip =~ $regex ]]; then
        return 1
    fi
    
    # Check each octet is between 0-255
    IFS='.' read -r -a octets <<< "$ip"
    for octet in "${octets[@]}"; do
        if [[ $octet -lt 0 || $octet -gt 255 ]]; then
            return 1
        fi
    done
    
    return 0
}

# Check if a string is a valid email format
is_valid_email() {
    [[ "$1" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}

# Check if a path is absolute
is_absolute_path() {
    [[ "$1" = /* ]]
}

# Validate input with custom error message
validate() {
    local value="$1"
    local validator="$2"
    local error_msg="$3"
    
    if ! $validator "$value"; then
        echo "$error_msg" >&2
        return 1
    fi
    return 0
}
