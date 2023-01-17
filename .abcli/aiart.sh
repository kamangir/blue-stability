#! /usr/bin/env bash

function blue_stability_generate() {
    local options=$2
    local options=$(abcli_option_default "$options" app blue_stability)
    local options=$(abcli_option_default "$options" image.args ++seed@42)
    local options=$(abcli_option_default "$options" video.args ++seed@42@++start_schedule@0.9)

    aiart_generate \
        "$1" \
        "$options" \
        "${@:3}"
}

function blue_stability_transform() {
    aiart_transform \
        $(abcli_option_default "$1" app blue_stability) \
        ${@:2}
}