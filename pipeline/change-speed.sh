#!/bin/bash
#
# Applies subtitles to given input video path.
# Returns path of output video.

set -e

SRC_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

source "${SRC_DIR}/utils.sh"

input_path="$(cat)"
input_name="$(echo "${input_path}" | basename "$(cat)" | strip_extension "$(cat)")"

speed="$1"
pts_multiplier=$(bc -l <<< "scale=2; 1/${speed}")

output_path="./outputs/${input_name}-x${speed}.mp4"

rm -f "${output_path}"

ffmpeg \
  -i "${input_path}" \
  -filter:v "setpts=${pts_multiplier}*PTS" \
  -c:a "copy" \
  "${output_path}"

echo "${output_path}"
