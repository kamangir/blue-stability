#! /usr/bin/env bash

function blue_stability_interactive() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ] ; then
        abcli_show_usage "blue_stability interactive$ABCUL[~dryrun,~sign]$ABCUL[--width 512 --height 512 --seed 42 --start_schedule 0.9]" \
            "interactive image generation."
        return
    fi

    abcli_tag set \
        $abcli_object_name \
        interactive

    local options=$1

    local i=0
    local sentence=""
    local filename=""
    while true; do
        local previous_sentence=$sentence

        local prompt="Enter to end paragraph: "
        if [ -z "$sentence" ] ; then
            local prompt="Enter to end: "
        fi

        read -p "$prompt" sentence

        if [ -z "$sentence" ] ; then
            if [ -z "$previous_sentence" ] ; then
                break
            fi
            continue
        fi

        local previous_filename=$filename
        if [ -z "$previous_sentence" ] ; then
            local previous_filename=""
        fi

        local filename=$(python3 -c "print(f'{$i:010d}')")

        blue_stability generate image \
            "$options" \
            "$filename" \
            "$previous_filename" \
            "$sentence" \
            ${@:2}

        ((i=i+1))
    done

    blue_stability render \
        "$options"
}