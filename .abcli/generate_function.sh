#! /usr/bin/env bash

function blue_stability_generate_function() {
    local options=$1
    local dryrun=$(abcli_option_int "$options" dryrun 1)

    local filename=$(abcli_clarify_input $2 frame)

    local prev_filename=$(abcli_clarify_input $3)

    local sentence=$4

    abcli_log "blue_stability: generate: image: \"$sentence\" -[$prev_filename.png ${@:5}]-> $filename.png"

    local extra_args=""
    if [ ! -z "$prev_filename" ] ; then
        local extra_args="--init ../raw/$prev_filename.png"
    fi

    local command_line="python3 -m stability_sdk.client \
        $extra_args \
        ${@:5} \
        \"$sentence\""

    abcli_log "⚙️  $command_line"

    if [ "$dryrun" == 1 ] ; then
        return
    fi

    local temp_path=$abcli_object_path/$app_name-$(abcli_string_timestamp)
    mkdir -p $temp_path

    pushd $temp_path > /dev/null
    eval $command_line
    popd > /dev/null

    mv -v $temp_path/*.png $abcli_object_path/raw/$filename.png
    mv -v $temp_path/*.json $abcli_object_path/raw/$filename.json

    cp -v \
        $abcli_object_path/raw/$filename.png \
        $abcli_object_path/$filename.png

    rm -rf $temp_path
}