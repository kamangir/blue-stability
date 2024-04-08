#! /usr/bin/env bash

function bstab() {
    blue_stability $@
}

function blue_stability() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ]; then
        abcli_show_usage "blue_stability dashboard" \
            "browse blue-stability dashboard."

        blue_stability_generate $@

        abcli_show_usage "blue_stability notebook" \
            "browse blue stability notebook."

        local task
        for task in pylint pytest test; do
            blue_stability $task "$@"
        done

        blue_stability_transform $@

        if [ "$(abcli_keyword_is $2 verbose)" == true ]; then
            python3 -m stability_sdk.client -h
        fi
        return
    fi

    local function_name="blue_stability_$task"
    if [[ $(type -t $function_name) == "function" ]]; then
        $function_name "${@:2}"
        return
    fi

    if [ "$task" == "dashboard" ]; then
        abcli_browse_url https://beta.dreamstudio.ai/membership
        return
    fi

    if [ "$task" == "notebook" ]; then
        pushd $abcli_path_git/blue-stability/nbs >/dev/null
        jupyter notebook
        popd >/dev/null
        return
    fi

    if [[ "|pylint|pytest|test|" == *"|$task|"* ]]; then
        abcli_${task} plugin=blue_stability,$2 \
            "${@:3}"
        return
    fi

    if [ "$task" == "version" ]; then
        python3 -m blue_stability version "${@:2}"
        return
    fi

    abcli_log_error "-blue_stability: $task: command not found."
}

abcli_source_path \
    $abcli_path_git/blue-stability/.abcli/tests
