#! /usr/bin/env bash

function blue_stability_generate_video() {
    local options=$1
    local app_name=$(abcli_option "$options" app blue_stability)

    if [ $(abcli_option_int "$options" help 0) == 1 ] ; then
        abcli_show_usage "$app_name generate video$ABCUL[app=<app-name>,~dryrun,frame_count=16,marker=PART,~publish,~render,resize_to=1280x1024,~sign,url]$ABCUL<filename.txt|url>$ABCUL[--width 768 --height 576 --seed 42 --start_schedule 0.9]" \
            "<filename.txt>|url -> video.mp4"
        return
    fi

    local is_url=$(abcli_option_int "$options" url 0)
    local frame_count=$(abcli_option_int "$options" frame_count -1)
    local marker=$(abcli_option "$options" marker)
    local dryrun=$(abcli_option_int "$options" dryrun 1)
    local do_render=$(abcli_option_int "$options" render 1)

    local options=$(abcli_option_default "$options" tag 0)

    local input_filename=$2

    abcli_log "blue-stability: generate: video: $input_filename -[${@:3}]-> $frame_count frame(s)"

    if [ "$is_url" == 1 ] ; then
        local input_filename=$abcli_object_path/script.txt
        curl "$2" --output $input_filename
    fi

    python3 -m blue_stability.script \
        flatten \
        --filename $input_filename \
        --frame_count $frame_count \
        --marker "$marker"

    local i=0
    local sentence
    local filename=""
    while IFS= read -r sentence ; do
        if [ -z "$sentence" ] ; then
            local filename=""
            continue
        fi

        local previous_filename=$filename
        local filename=$(python3 -c "print(f'{$i:010d}')")

        blue_stability generate image \
            "$options" \
            "$filename" \
            "$previous_filename" \
            "$sentence" \
            ${@:3}

        ((i=i+1))
    done < "$input_filename"

    if [ "$dryrun" == 0 ] ; then
        abcli_tag set \
            $abcli_object_name \
            $app_name

        if [ "$do_render" == 1 ] ; then
            blue_stability render \
                "$options"
        fi
    fi
}