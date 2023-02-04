#!/usr/bin/env bash

readonly BASE_DIR=$(dirname $(realpath $0))

print_help () {
    cat << _EOT_
Usage: $(basename $0) [OPTION]... SEARCH_WORD

English-Japanese dictionary for Bash

Options:
    -h, --help          display this help and exit
    -w, --whole         match only whole SEARCH_WORD
_EOT_
}

main () {
    local opts whole='false' cmdline

    opts=$(getopt -o 'hw' -l 'help,whole' -- "$@") || {
        print_help | head -n 1 >&2
        exit 1
    }
    eval "set -- $opts"

    while (( $# > 0 ))
    do
        case "$1" in
            -h | --help )
                print_help
                exit 0
            ;;
            -w | --whole )
                whole='true'
            ;;
            -- )
                shift
                break
            ;;
        esac
        shift
    done

    if (( $# < 1 )); then
        print_help | head -n 1 >&2
        exit 1
    fi

    cmdline=('grep -i --color=auto')

    if [[ "$1" =~ ^[a-zA-Z\ ]+$ ]]; then
        cmdline+=('-A 1')
    else
        cmdline+=('-B 1')
    fi

    if eval "$whole"; then
        cmdline+=('-w')
    fi

    cmdline+=("'$1' $BASE_DIR/gene.txt")

    eval "${cmdline[@]}"
}

main "$@"