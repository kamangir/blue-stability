#! /usr/bin/env bash

function abcli_install_blue_stability() {
    pip3 install stability-sdk
    pip3 install torchvision
    # https://github.com/carpedm20/emoji
    pip3 install emoji
}

abcli_install_module blue_stability 103