function get_search_path_opt() {
    local search_path=$(git rev-parse --show-cdup 2>/dev/null)
    if [[ -n $search_path ]]; then
        echo "--search-path ${search_path}"
    else
        echo ""
    fi
}

function fzf-fd() {
    local search_path_opt=$(=get_search_path_opt)
    local out=$(fd -HI --ignore-file ~/.ignore -c always -t f ${search_path_opt} | \
        fzf --ansi --multi --reverse \
        --preview 'bat --plain --number --color always {}' \
        --preview-window down:70% \
        --bind "alt-h:reload:fd -HI -c always -t f ${search_path_opt}" \
    )
    if [[ -n "$out" ]]; then
        out=$(echo "$out" | sed "s/.*/'&'/" | tr '\n' ' ' | sed 's/ $//')
        LBUFFER="${LBUFFER}${out}"
        CURSOR="${#LBUFFER}"
    fi
    zle redisplay
}
zle -N fzf-fd
