#!/bin/bash
#
# Applies sharp VHS filter to given input video path.
# Returns path of output video.

set -e

source ./utils.sh

input="$(cat)"
filename="$(basename "${input}")"
output="./outputs/$(strip_extension "${filename}")-vhs-sharpen.mp4"

ffmpeg \
  -i "${input}" \
  -vf convolution="-2 -1 0 -1 1 1 0 1 2:-2 -1 0 -1 1 1 0 1 2:-2 -1 0 -1 1 1 0 1 2:-2 -1 0 -1 1 1 0 1 2" \
  -c:a copy \
  "${output}"

echo "${output}"
