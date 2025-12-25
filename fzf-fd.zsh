function fzf-fd() {
    local out
    out=$(fd --type f --hidden --follow --exclude .git | fzf --multi)
    if [[ -n "$out" ]]; then
        out=$(echo "$out" | tr '\n' ' ' | sed 's/ $//')
        LBUFFER="${LBUFFER}${out}"
        CURSOR="${#LBUFFER}"
    fi
    zle redisplay
}
zle -N fzf-fd
