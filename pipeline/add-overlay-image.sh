#!/bin/bash
#
# Applies overlay image to given input video path.
# Returns path of output video.

set -e

SRC_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

source "${SRC_DIR}/utils.sh"

input_path="$(cat)"
input_name="$(echo "${input_path}" | basename "$(cat)" | strip_extension "$(cat)")"

overlay_path="$1"
overlay_name="$(echo "${overlay_path}" | basename "$(cat)" | strip_extension "$(cat)")"

overlay_timecode_seconds="$2"

output_path="./outputs/${input_name}-overlayed-${overlay_name}.mp4"

filter_complex="overlay=enable='between(t,${overlay_timecode_seconds},${overlay_timecode_seconds}+1)':x=(main_w-overlay_w)/2:y=(main_h-overlay_h)/2"

ffmpeg \
  -i "${input_path}" \
  -i "${overlay_path}" \
  -filter_complex "${filter_complex}" \
  -c:a "copy" \
  "${output_path}"

echo "${output_path}"
