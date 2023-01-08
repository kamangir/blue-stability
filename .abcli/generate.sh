#! /usr/bin/env bash

function blue_stability_generate() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ] ; then
        blue_stability_generate_image $@
        blue_stability_generate_video $@
        blue_stability_generate_validate $@
        return
    fi

    local function_name="blue_stability_generate_$1"
    if [[ $(type -t $function_name) == "function" ]] ; then
        $function_name "${@:2}"
        return
    fi

    blue_stability_generate_image "$@"
}