#!/bin/bash
#
# Applies subtitles to given input video path.
# Returns path of output video.

set -e

source ./utils.sh

input="$(cat)"
speed=$(bc -l <<< "scale=2; 1/$1")
subtitles_path="$1"
filename="$(basename "${input}")"
output="./outputs/$(strip_extension "${filename}")-x$1.mp4"

ffmpeg \
  -i "${input}" \
  -filter:v "setpts=${speed}*PTS" \
  -c:a copy \
  "${output}"

echo "${output}"
