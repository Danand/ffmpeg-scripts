#!/bin/bash
#
# Applies overlay image to given input video path.
# Returns path of output video.

set -e

source ./utils.sh

input="$(cat)"
overlay_path="$1"
overlay_timecode_seconds="$2"
filename="$(basename "${input}")"
output="./outputs/$(strip_extension "${filename}")-overlayed.mp4"

filter_complex="overlay=enable='between(t,${overlay_timecode_seconds},${overlay_timecode_seconds}+1)':x=(main_w-overlay_w)/2:y=(main_h-overlay_h)/2"

ffmpeg \
  -i "${input}" \
  -i "${overlay_path}" \
  -filter_complex "${filter_complex}" \
  -c:a copy \
  "${output}"

echo "${output}"
