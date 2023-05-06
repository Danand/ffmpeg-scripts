#!/bin/bash
#
# Applies audio to given input video path.
# Returns path of output video.

set -e

SRC_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

source "${SRC_DIR}/utils.sh"

input_path="$(cat)"
input_name="$(echo "${input_path}" | basename "$(cat)" | strip_extension "$(cat)")"

audio_path="$1"
audio_name="$(echo "${audio_path}" | basename "$(cat)" | strip_extension "$(cat)")"

output_path="./outputs/${input_name}-${audio_name}.mp4"

ffmpeg \
  -i "${input_path}" \
  -i "${audio_path}" \
  -c "copy" \
  -map "0:v:0" \
  -map "1:a:0 "\
  "${output_path}"

echo "${output_path}"
