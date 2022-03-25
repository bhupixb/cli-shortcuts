# Gives a quick summary on how to do something with a cli tool
how() {
    # set -x
    local args=$@
    local cheat_sh_format="$(echo $args | sed "s/ /\//g")"
    curl "cheat.sh/${cheat_sh_format}"
}

# extract json object with matchings keys only
json() {
    #gron | grep -Ew 'spec\.containers\[.\]\.(resources|name|env)' | gron --ungron
    gron | grep $@ | grep -v 'kubectl.kubernetes.io/last-applied-configuration' | gron --ungron
}
