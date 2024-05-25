#! /usr/bin/env bash

function blue_stability_action_git_before_push() {
    blue_stability pypi build
}
