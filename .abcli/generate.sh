#! /usr/bin/env bash

function blue_stability_generate() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ] ; then
        local options=$2
        local app_name=$(abcli_option "$options" app blue_stability)

        blue_stability_generate_image help,app=$app_name
        blue_stability_generate_video help,app=$app_name
        blue_stability_generate_validate help,app=$app_name

        return
    fi

    local function_name="blue_stability_generate_$1"
    if [[ $(type -t $function_name) == "function" ]] ; then
        $function_name "${@:2}"
        return
    fi

    blue_stability_generate_image "$@"
}