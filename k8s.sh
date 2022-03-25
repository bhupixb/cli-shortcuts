#!/bin/bash

# enable/disable debug mode
# set -x

# colors
red='\033[0;31m'
yellow='\033[0;33m'
green='\033[0;32m'
NC='\033[0m' # No Color

ns() {
   kubectl config set-context --current --namespace=$1
}

commonInfo() {
    local namespace=$(kubectl config view --minify --output 'jsonpath={..namespace}')
    echo "${yellow}[INFO] default namespace: ${green}${namespace:-'not found :('}${NC}${NC}"
}

pods() {
    kubectl get pod $@
    commonInfo
}

deploy() {
    kubectl get deploy $@
    commonInfo
}

des() {
    k describe $@
    commonInfo
}

plogs() {
    k logs $@
}

usage() {
    echo $@
    kubectl top pod ${@}
    echo "[INFO] executing ${cmd}"
}

useContext() {
    local context=${1}
    echo "${yellow}[INFO] switching to context: ${green}${context}${NC}${NC}"
    kubectl config use-context ${context}
}

use() {
    local context=${1}

    # use stage context
    if [ ${context} = 'stage' ];
    then
        context='zone-aws-default-staging-mumbai'
    fi

    # # use stage context
    # if [ ${context} = 'local' || ${context} = 'docker' ];
    # then
    #     context='docker-desktop'
    # fi

    # use pp context
    if [ ${context} = 'pp' ];
    then
        context='zone-aws-default-pp-mumbai'
    fi

    # use prod context
    if [ ${context} = 'prod' ];
    then
        context='zone-aws-common-prod-mumbai'
    fi

    # use prod context
    if [ ${context} = 'lon' ];
    then
        context='zone-aws-sodexo-prod-london'
    fi

    # use beta context
    if [ ${context} = 'beta' ];
    then
        context='zone-aws-hdfc-beta-mumbai'
    fi

    useContext ${context}
}

podContainers() {
    kubectl get pod $@ --output=json | jq '.spec.containers[] | .name + "   " + .image'
}

depContainers() {
    k get deploy $@ --output=json | jq '.spec.template.spec.containers[] | .name + " " + .image'
}

cpuThrottling() {
    local x=$@
    echo 'sum(increase(container_cpu_cfs_throttled_periods_total{namespace="ganymede", pod=~"replace_me.*", container=~"postgrest|pglisten|openresty"}[1m])) by (pod) /sum(increase(container_cpu_cfs_periods_total{namespace="ganymede", pod=~"replace_me.*", container=~"postgrest|pglisten|openresty"}[1m])) by (pod)' | sed 's/replace_me/'${x}'/g'; echo '* 100'}
