#! /usr/bin/env bash

function blue_stability_generate_image() {
    local options=$1
    local app_name=$(abcli_option "$options" app blue_stability)

    if [ $(abcli_option_int "$options" help 0) == 1 ] ; then
        abcli_show_usage "$app_name generate image$ABCUL[app=<app-name>,~dryrun,~sign,~tag]$ABCUL[<image>] [<previous-image>]$ABCUL[\"<sentence>\"]$ABCUL[--width 768 --height 576 --seed 42]" \
            "<sentence> -[<previous-image>]-> <image>.png."
        return
    fi

    mkdir -p $abcli_object_path/raw

    local dryrun=$(abcli_option_int "$options" dryrun 1)
    local do_sign=$(abcli_option_int "$options" sign 1)
    local do_tag=$(abcli_option_int "$options" tag 1)

    local filename=$(abcli_clarify_input $2 frame)

    local prev_filename=$(abcli_clarify_input $3)

    local sentence=$4

    if [ -z "$prev_filename" ] ; then
        abcli_log "📘  $i: $sentence"
    else
        abcli_log "📖  $i: $sentence"
    fi

    abcli_log "$app_name: generate: image: \"$sentence\" -[$prev_filename.png ${@:5}]-> $filename.png"

    if [ "$do_tag" == 1 ] ; then
        abcli_tag set \
            $abcli_object_name \
            $app_name
    fi

    local command_line=""
    if [ "$app_name" == blue_stability ] ; then
        local extra_args=""
        if [ ! -z "$prev_filename" ] ; then
            local extra_args="--init ../raw/$prev_filename.png"
        fi

        local command_line="python3 -m stability_sdk.client \
            $extra_args \
            ${@:5} \
            \"$sentence\""
    elif [ "$app_name" == openai ] ; then
        if [ -z "$prev_filename" ] ; then
            local command_line="curl https://api.openai.com/v1/images/generations \
                -H 'Content-Type: application/json' \
                -H 'Authorization: Bearer $OPENAI_API_KEY' \
                -d '{
                \"prompt\": \"$sentence\",
                \"n\": 1,
                \"size\": \"1024x1024\"
                }' >> ./$filename.json"
        else
            local command_line=""
        fi
    else
        abcli_log_error "-blue-stability: generate: image: $app_name: application not found."
        return
    fi

    abcli_log $command_line

    if [ "$dryrun" == 1 ] ; then
        return
    fi

    local temp_path=$abcli_object_path/$app_name-$(abcli_string_timestamp)
    mkdir -p $temp_path

    pushd $temp_path > /dev/null
    eval $command_line
    popd > /dev/null

    if [ "$app_name" == openai ] ; then
        local image_url=$(jq ".data[0][url]" ./raw/$filename.json)

        curl -o ./raw/$filename.png $image_url

    fi

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

    python3 -m abcli.modules.host \
        add_signature \
        --application $app_name-$(python3 -m $app_name version) \
        --filename $abcli_object_path/$filename.png \
        --footer "$footer"

    local content=$(echo "$extra_args ${@:4}" | base64)
    python3 -m Kanata.metadata \
        update \
        --is_base64_encoded 1 \
        --keyword $app_name.$filename.args \
        --content "$content" \
        --object_path $abcli_object_path

    rm -rf $temp_path
}