#!/bin/bash
#
# Applies audio to given input video path.
# Returns path of output video.

set -e

source ./utils.sh

input="$(cat)"
audio_path="$1"
filename="$(basename "${input}")"
output="./outputs/$(strip_extension "${filename}")-with-audio.mp4"

ffmpeg \
  -i "${input}" \
  -i "${audio_path}" \
  -c copy \
  -map 0:v:0 \
  -map 1:a:0 \
  "${output}"

echo "${output}"
