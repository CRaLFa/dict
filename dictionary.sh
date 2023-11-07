#!/usr/bin/env bash

readonly BASE_DIR=$(dirname $(realpath $0))

usage () {
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
        usage | head -n 1 >&2
        return 1
    }
    eval "set -- $opts"

    while (( $# > 0 ))
    do
        case "$1" in
            -h | --help )
                usage
                return 0
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
        usage | head -n 1 >&2
        return 1
    fi

    cmdline=('grep -E -i --color=auto')

    if [[ "$1" =~ [ぁ-んァ-ヶ亜-熙] ]]; then
        cmdline+=('-B 1')
    else
        cmdline+=('-A 1')
    fi

    if eval "$whole"; then
        cmdline+=('-w')
    fi

    cmdline+=("'$1' $BASE_DIR/gene.txt")

    eval "${cmdline[@]}"
}

main "$@"
