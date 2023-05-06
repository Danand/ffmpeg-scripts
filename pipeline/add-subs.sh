#!/bin/bash
#
# Applies retro yellow subtitles to given input video path.
# Returns path of output video.

set -e

SRC_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

source "${SRC_DIR}/utils.sh"

input_path="$(cat)"
input_name="$(echo "${input_path}" | basename "$(cat)" | strip_extension "$(cat)")"

subtitles_path="$1"
subtitles_name="$(echo "${subtitles_path}" | basename "$(cat)" | strip_extension "$(cat)")"

output_path="./outputs/${input_name}-${subtitles_name}.mp4"

subtitles_filter="subtitles"

if echo "${subtitles_path}" | grep -q "\.ass$"; then
  subtitles_filter="ass"
fi

video_filter="subtitles=${subtitles_path}"

ffmpeg \
  -i "${input_path}" \
  -vf "${video_filter}" \
  "${output_path}"

echo "${output_path}"
