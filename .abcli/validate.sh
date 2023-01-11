#! /usr/bin/env bash

function blue_stability_generate_validate() {
    local options=$1
    local app_name=$(abcli_option "$options" app blue_stability)

    if [ $(abcli_option_int "$options" help 0) == 1 ] ; then
        abcli_show_usage "$app_name generate validate$ABCUL[app=<app-name>,dryrun,what=all|image|video]" \
            "validate $app_name."
        return
    fi

    local dryrun=$(abcli_option_int "$options" dryrun 0)
    local what=$(abcli_option "$options" what all)

    if [ "$what" == "all" ] ; then
        blue_stability_generate_validate \
            app=$app_name,dryrun=$dryrun,what=image
        blue_stability_generate_validate \
            app=$app_name,dryrun=$dryrun,what=video
        return
    fi

    if [ "$what" == "image" ] ; then
        blue_stability generate image \
            app=$app_name,dryrun=$dryrun \
            validation - \
            "an orange carrot walking on Mars." \
            --seed 42
        return
    fi

    if [ "$what" == "video" ] ; then
        blue_stability generate video \
            app=$app_name,dryrun=$dryrun,frame_count=3,marker=PART,url \
            https://www.gutenberg.org/cache/epub/51833/pg51833.txt \
            --seed 42 \
            --start_schedule 0.9
        return
    fi

    abcli_log_error "-$app_name: generate: validate: $what: command not found."
}