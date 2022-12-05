#! /usr/bin/env bash

function blue_stability_generate_image() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ] ; then
        abcli_show_usage "blue_stability generate image$ABCUL[~dryrun,~sign,~tag]$ABCUL[<image>] [<previous-image>]$ABCUL[\"<sentence>\"]$ABCUL[--width 768 --height 576 --seed 42]" \
            "<sentence> -[<previous-image>]-> <image>.png."
        return
    fi

    mkdir -p $abcli_object_path/raw

    local temp_path=$abcli_object_path/_blue_stability_temp
    mkdir -p $temp_path

    local options=$1
    local dryrun=$(abcli_option_int "$options" dryrun 1)
    local do_sign=$(abcli_option_int "$options" sign 1)
    local do_tag=$(abcli_option_int "$options" tag 1)

    local filename=$(abcli_clarify_input $2 frame)
    local prev_filename=$(abcli_clarify_input $3)

    local sentence=$4

    local extra_args=""
    if [ -z "$prev_filename" ] ; then
        abcli_log "📘  $i: $sentence"
    else
        local extra_args="--init ../raw/$prev_filename.png"
        abcli_log "📖  $i: $sentence"
    fi

    abcli_log "blue-stability: generate: image: \"$sentence\" -[$prev_filename.png ${@:5}]-> $filename.png"

    if [ "$do_tag" == 1 ] ; then
        abcli_tag set \
            $abcli_object_name \
            blue_stability
    fi

    local command="python3 -m stability_sdk.client $extra_args ${@:5} \"$sentence\""

    abcli_log $command
    if [ "$dryrun" == 1 ] ; then
        rm -rf $temp_path
        return
    fi

    pushd $temp_path > /dev/null
    eval $command
    popd > /dev/null

    mv -v $temp_path/*.png $abcli_object_path/raw/$filename.png
    mv -v $temp_path/*.json $abcli_object_path/raw/$filename.json

    cp -v \
        $abcli_object_path/raw/$filename.png \
        $abcli_object_path/$filename.png

    if [ "$do_sign" == 1 ] ; then
        local footer=$sentence

        if [ -z "$prev_filename" ] ; then
            local footer="* $footer"
        fi
    else
        local footer=""
    fi
    local footer="$footer | ${@:5}"

    local version=$(python3 -c "from stability_sdk import VERSION; print(VERSION)")

    python3 -m abcli.modules.host \
        add_signature \
        --application "blue-stability-$version" \
        --filename $abcli_object_path/$filename.png \
        --footer "$footer"

    local content=$(echo "$extra_args ${@:4}" | base64)
    python3 -m Kanata.metadata \
        update \
        --is_base64_encoded 1 \
        --keyword stability_sdk.$filename.args \
        --content "$content" \
        --object_path $abcli_object_path

    rm -rf $temp_path
}