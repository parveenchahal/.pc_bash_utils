#!/usr/bin/env bash

__pbu_install "$HOME/.pc_bash_utils/pssh"

complete -W "--escape_args -u --user -h --host -e --exit-master-connection -p --x11 --verbose" pssh