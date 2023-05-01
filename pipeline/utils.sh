#!/bin/bash
#
# Common utils for `ffmpeg` scripts.

function strip_extension() {
  echo "$1" | rev | cut -d "." -f2- | rev
}
