#! /usr/bin/env bash

function blue_stability_validate() {
    local task=$(abcli_unpack_keyword $1 all)

    if [ $task == "help" ] ; then
        abcli_show_usage "blue_stability validate$ABCUL[generate|generate_image|generate_video]" \
            "validate blue_stability."
        return
    fi

    if [ "$task" == "all" ] ; then
        blue_stability_validate generate
        return
    fi

    if [ "$task" == "generate" ] ; then
        blue_stability_validate generate_image
        blue_stability_validate generate_video
        return
    fi

    if [ "$task" == "generate_image" ] ; then
        blue_stability generate image \
            ~dryrun \
            validation - \
            "an orange carrot walking on Mars." \
            --seed 42
        return
    fi

    if [ "$task" == "generate_video" ] ; then
        blue_stability generate video \
            ~dryrun,frame_count=3,marker=PART,url \
            https://www.gutenberg.org/cache/epub/51833/pg51833.txt \
            --seed 42 \
            --start_schedule 0.9
        return
    fi

    abcli_log_error "-blue_stability: validate: $task: command not found."
}