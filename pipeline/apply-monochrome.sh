#!/bin/bash
#
# Applies weird black and white filter to given input video path.
# Returns path of output video.

set -e

source ./utils.sh

input_path="$(cat)"
input_name="$(echo "${input_path}" | basename "$(cat)" | strip_extension "$(cat)")"

output_path="./outputs/${input_name}-monochrome.mp4"

video_filter="colorchannelmixer=rr=0.3:gg=0.11:bb=0.11"

ffmpeg \
  -i "${input_path}" \
  -vf "${video_filter}" \
  -c:a "copy" \
  "${output_path}"

echo "${output_path}"
