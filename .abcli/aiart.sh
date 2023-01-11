#! /usr/bin/env bash

function blue_stability_generate() {
    aiart_generate \
        "$1" \
        $(abcli_option_default "$2" app blue_stability) \
        "${@:3}"
}

function blue_stability_transform() {
    aiart_transform \
        $(abcli_option_default "$1" app blue_stability) \
        ${@:2}
}