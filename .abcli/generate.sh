#! /usr/bin/env bash

function blue_stability_generate() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ] ; then
        local options=$2

        blue_stability_generate_image $task,$options
        blue_stability_generate_video $task,$options
        blue_stability_generate_validate $task,$options

        return
    fi

    local function_name="blue_stability_generate_$1"
    if [[ $(type -t $function_name) == "function" ]] ; then
        $function_name "${@:2}"
        return
    fi

    blue_stability_generate_image "$@"
}