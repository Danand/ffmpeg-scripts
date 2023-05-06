#!/bin/bash
#
# Applies sharp VHS filter to given input video path.
# Returns path of output video.

set -e

SRC_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

source "${SRC_DIR}/utils.sh"

input_path="$(cat)"
input_name="$(echo "${input_path}" | basename "$(cat)" | strip_extension "$(cat)")"

output_path="./outputs/${input_name}-vhs-sharpen.mp4"

ffmpeg \
  -i "${input_path}" \
  -vf "convolution='-2 -1 0 -1 1 1 0 1 2:-2 -1 0 -1 1 1 0 1 2:-2 -1 0 -1 1 1 0 1 2:-2 -1 0 -1 1 1 0 1 2'" \
  -c:a "copy" \
  "${output_path}"

echo "${output_path}"
