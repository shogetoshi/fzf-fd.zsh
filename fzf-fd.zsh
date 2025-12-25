function get_dir() {
    echo ""
}

function get_query() {
    echo ""
}

function get_lbuf() {
    echo "$1"
}

function get_rbuf() {
    echo "$1"
}

function get_search_path_opt() {
    local search_path=$(git rev-parse --show-cdup 2>/dev/null)
    if [[ -n $search_path ]]; then
        echo "--search-path ${search_path}"
    else
        echo ""
    fi
}

function fzf-fd() {
    local dir=$(get_dir "${LBUFFER}" "${RBUFFER}")
    local query=$(get_query)
    local lbuf=$(get_lbuf ${LBUFFER})
    local rbuf=$(get_rbuf ${RBUFFER})
    if [[ -z $dir ]]; then
        local search_path_opt=$(=get_search_path_opt)
        local out=$(fd -HI --ignore-file ~/.ignore -c always -t f ${search_path_opt} | \
            fzf --ansi --multi --reverse \
            --query "$query" \
            --preview 'bat --plain --number --color always {}' \
            --preview-window down:70% \
            --bind "alt-h:reload:fd -HI -c always -t f ${search_path_opt}" \
        )
        if [[ -n "$out" ]]; then
            out=$(echo "$out" | sed "s/.*/'&'/" | tr '\n' ' ' | sed 's/ $//')
            LBUFFER="${lbuf}${out}"
            CURSOR="${#LBUFFER}"
        fi
    else
        :
    fi
    zle redisplay
}
zle -N fzf-fd
