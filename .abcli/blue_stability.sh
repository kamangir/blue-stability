#! /usr/bin/env bash

export STABILITY_KEY=$(abcli_cookie read stability_key)
export STABILITY_HOST=grpc.stability.ai:443

function bstab() {
    blue_stability $@
}

function blue_stability() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ] ; then
        abcli_show_usage "blue_stability dashboard" \
            "open blue stability dashboard."

        blue_stability_generate $@
        blue_stability_interactive $@

        abcli_show_usage "blue_stability notebook" \
            "browse blue stability notebook."

        blue_stability_render $@
        blue_stability_transform $@

        if [ "$(abcli_keyword_is $2 verbose)" == true ] ; then
            python3 -m stability_sdk.client -h
        fi

        return
    fi

    local function_name="blue_stability_$task"
    if [[ $(type -t $function_name) == "function" ]] ; then
        $function_name "${@:2}"
        return
    fi

    if [ "$task" == "dashboard" ] ; then
        abcli_browse_url https://beta.dreamstudio.ai/membership
        return
    fi

    if [ "$task" == "notebook" ] ; then
        pushd $abcli_path_git/blue-stability/nbs > /dev/null
        jupyter notebook
        popd > /dev/null
        return
    fi

    abcli_log_error "-blue_stability: $task: command not found."
}

