git-archpkg() {
    if [ -z "$1" ]; then
        echo "Usage: gitpkg package_name"
        return 1
    fi
    
    git clone "https://gitlab.archlinux.org/archlinux/packaging/packages/$1.git" && cd "$1"
}

