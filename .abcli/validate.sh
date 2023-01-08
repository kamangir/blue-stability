#! /usr/bin/env bash

function blue_stability_generate_validate() {
    local task=$(abcli_unpack_keyword $1 all)

    if [ $task == "help" ] ; then
        local options=$2
        local app_name=$(abcli_option "$2" app blue_stability)

        abcli_show_usage "$app_name generate validate$ABCUL[app=<app-name>,what=all|image|video]" \
            "validate $app_name."
        return
    fi

    local options=$1
    local app_name=$(abcli_option "$2" app blue_stability)
    local what=$(abcli_option "$2" what all)

    if [ "$what" == "all" ] ; then
        blue_stability_generate_validate \
            app=$app_name,what=image
        blue_stability_generate_validate \
            app=$app_name,what=video
        return
    fi

    if [ "$what" == "image" ] ; then
        blue_stability generate image \
            app=$app_name,~dryrun \
            validation - \
            "an orange carrot walking on Mars." \
            --seed 42
        return
    fi

    if [ "$what" == "video" ] ; then
        blue_stability generate video \
            app=$app_name,~dryrun,frame_count=3,marker=PART,url \
            https://www.gutenberg.org/cache/epub/51833/pg51833.txt \
            --seed 42 \
            --start_schedule 0.9
        return
    fi

    abcli_log_error "-blue_stability: generate: validate: $what: command not found."
}