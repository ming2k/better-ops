function bg {
    nohup "$@" > /dev/null 2>&1 &
    echo "Command '$@' running in background (PID: $!)"
}
