
how() {
    # set -x
    local args=$@
    local cheat_sh_format="$(echo $args | sed "s/ /\//g")"
    curl "cheat.sh/${cheat_sh_format}"
}
