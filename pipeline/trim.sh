#!/bin/bash
#
# Trims video of given input video path using given frame numbers: from and to.
# Returns trimmed output video.

set -e

SRC_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

source "${SRC_DIR}/utils.sh"

input_path="$(cat)"
input_name="$(echo "${input_path}" | basename "$(cat)" | strip_extension "$(cat)")"

frame_from="$1"
frame_to="$2"

output_path="./outputs/${input_name}-${frame_from}-${frame_to}.mp4"

ffmpeg \
  -i "${input_path}" \
  -filter:v "trim=start_frame=${frame_from}:end_frame=${frame_to},setpts=PTS-STARTPTS" \
  -c:a "copy" \
  "${output_path}"

echo "${output_path}"
