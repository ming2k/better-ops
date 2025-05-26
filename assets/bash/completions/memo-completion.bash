#!/usr/bin/env bash

# Bash completion function for the memo script
_memo_completion() {
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    
    # Main commands
    local commands="new explore search todo doodle help"
    
    # Options for specific commands
    local new_options="-t --tag"
    local explore_options="--edit --print"
    local search_options="--string --regex -t --tag"
    local todo_options="-a --add -c --complete -i --interactive -h --help"
    
    # Complete main commands
    if [[ ${COMP_CWORD} -eq 1 ]]; then
        COMPREPLY=( $(compgen -W "${commands}" -- "${cur}") )
        return 0
    fi
    
    # Command-specific completions
    case "${COMP_WORDS[1]}" in
        new)
            case "${prev}" in
                -t|--tag)
                    # Try to complete with existing tags from notes
                    local tags
                    if command -v rg &>/dev/null && [[ -d ~/notes ]]; then
                        tags=$(rg -o --no-filename --no-line-number '  - ([a-zA-Z0-9_-]+)' ~/notes | sed 's/  - //' | sort -u)
                        COMPREPLY=( $(compgen -W "${tags}" -- "${cur}") )
                    fi
                    ;;
                *)
                    COMPREPLY=( $(compgen -W "${new_options}" -- "${cur}") )
                    ;;
            esac
            ;;
        explore)
            COMPREPLY=( $(compgen -W "${explore_options}" -- "${cur}") )
            ;;
        search)
            case "${prev}" in
                -t|--tag)
                    # Try to complete with existing tags from notes
                    local tags
                    if command -v rg &>/dev/null && [[ -d ~/notes ]]; then
                        tags=$(rg -o --no-filename --no-line-number '  - ([a-zA-Z0-9_-]+)' ~/notes | sed 's/  - //' | sort -u)
                        COMPREPLY=( $(compgen -W "${tags}" -- "${cur}") )
                    fi
                    ;;
                *)
                    COMPREPLY=( $(compgen -W "${search_options}" -- "${cur}") )
                    ;;
            esac
            ;;
        todo)
            case "${prev}" in
                -c|--complete)
                    # Try to complete with active todo items
                    local todos
                    if [[ -f ~/notes/todo.md ]]; then
                        todos=$(grep '^\- \[ \]' ~/notes/todo.md | sed 's/^\- \[ \] [0-9-]* [0-9:]*: //' | sort)
                        COMPREPLY=( $(compgen -W "${todos}" -- "${cur}") )
                    fi
                    ;;
                *)
                    COMPREPLY=( $(compgen -W "${todo_options}" -- "${cur}") )
                    ;;
            esac
            ;;
    esac
    
    return 0
}

# Register the completion function
complete -F _memo_completion memo
