#! /usr/bin/env bash

function blue_stability_transform() {
    local task=$(abcli_unpack_keyword $1 help)

    if [ $task == "help" ] ; then
        abcli_show_usage "blue_stability transform$ABCUL[count=<1>,~dryrun,extension=jpg,~sign,~tag,~upload]$ABCUL[<object-name>]$ABCUL[\"<sentence>\"]$ABCUL[--width 768 --height 576 --seed 42 --start_schedule 0.9]" \
            "<object-name> -<sentence>-> $abcli_object_name."
        return
    fi

    local destination_object=$abcli_object_name

    local options=$1
    local count=$(abcli_option_int "$options" count -1)
    local do_upload=$(abcli_option_int "$options" upload 1)
    local do_tag=$(abcli_option_int "$options" tag 1)
    local extension=$(abcli_option "$options" extension jpg)

    local source_object=$(abcli_clarify_object $2 ..)

    local sentence=$3

    abcli_log "blue-stability: transform: $source_object -[\"$sentence\" ${@:4}]-> $destination_object [count:$count]"

    abcli_select $source_object ~trail

    abcli_download

    mkdir -p $abcli_object_root/$destination_object/raw/

    local list_of_images=""
    local i=0
    local filename
    for filename in *.$extension ; do
        local list_of_images="$list_of_images ${filename%.*}"

        python3 -m blue_stability.image \
            convert \
            --source $abcli_object_path/$filename \
            --destination $abcli_object_root/$destination_object/raw/${filename%.*}-source.png \
            ${@:4}

        ((i=i+1))

        if [ "$count" != -1 ] ; then
            if [[ "$i" -ge "$count" ]] ; then
                break
            fi
        fi
    done
    abcli_log_list "$list_of_images" space "images(s)" "transforming "

    abcli_select $destination_object ~trail

    local filename
    local options_=$(abcli_option_default "$options" tag 0)
    for filename in $list_of_images ; do
        blue_stability generate image \
            "$options_" \
            $filename \
            $filename-source \
            "$sentence" \
            ${@:4}
    done

    if [ "$do_tag" == 1 ] ; then
        abcli_tag set \
            $destination_object \
            blue_stability
    fi

    if [ "$do_upload" == 1 ] ; then
        abcli_upload
    fi
}