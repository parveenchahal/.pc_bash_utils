#!/usr/bin/env bash

function textedit() {
  pbu.is_macos || pbu.errors.echo "Not supported" || return 1
  open -a TextEdit "$1"
}
