#! /usr/bin/env bash

function blue_stability_render() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ] ; then
        abcli_show_usage "blue_stability render$ABCUL[fps=5,~publish,resize_to=$ABCLI_VIDEO_DEFAULT_SIZE,~rm_frames]" \
            "create video and publish."
        return
    fi

    local options=$1
    local options=$(abcli_option_default "$options" fps 5)
    local options=$(abcli_option_default "$options" rm_frames 0)
    local options=$(abcli_option_default "$options" resize_to $ABCLI_VIDEO_DEFAULT_SIZE)
    local do_publish=$(abcli_option_int "$options" publish 1)

    abcli_log "blue-stability: render: $options"

    abcli_create_video \
        .png \
        video \
        "$options"

    if [ -f "video.gif" ] ; then
        rm -rv video.gif
    fi

    ffmpeg -i \
        video.mp4 \
        video.gif

    if [ "$do_publish" == 1 ] ; then
        abcli_upload

        abcli_publish \
            $abcli_object_name \
            video.gif

        abcli_publish \
            $abcli_object_name \
            .png
    fi
}