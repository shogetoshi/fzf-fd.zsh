function fzf-fd() {
    local out
    out=$(fd -HI --ignore-file ~/.ignore -c always -t f | \
        fzf --ansi --multi --reverse \
        --preview 'bat --plain --number --color always {}' \
        --preview-window down:70%)
    if [[ -n "$out" ]]; then
        out=$(echo "$out" | sed "s/.*/'&'/" | tr '\n' ' ' | sed 's/ $//')
        LBUFFER="${LBUFFER}${out}"
        CURSOR="${#LBUFFER}"
    fi
    zle redisplay
}
zle -N fzf-fd
