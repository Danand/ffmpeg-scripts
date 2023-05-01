#!/bin/bash
#
# Applies black and white filter to given input video path.
# Returns path of output video.

set -e

source ./utils.sh

input="$(cat)"
filename="$(basename "${input}")"
output="./outputs/$(strip_extension "${filename}")-bw.mp4"

filtergraph="colorchannelmixer=rr=0.3:gg=0.59:bb=0.11"

ffmpeg \
  -i "${input}" \
  -vf "${filtergraph}" \
  -c:a copy \
  "${output}"

echo "${output}"
