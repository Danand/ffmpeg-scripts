#!/bin/bash
#
# Applies anime-like filter.
# Returns path of output video.

set -e

SRC_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

source "${SRC_DIR}/utils.sh"

input_path="$(cat)"
input_name="$(echo "${input_path}" | basename "$(cat)" | strip_extension "$(cat)")"

overlay_timecode_seconds="$2"

output_path="./outputs/${input_name}-anime.mp4"

filter_complex="colorchannelmixer=rr=0.3:rg=0.4:rb=0.3:gr=0.2:gg=0.6:gb=0.2:br=0.1:bg=0.4:bb=0.5"

rm -f "${output_path}"

ffmpeg \
  -i "${input_path}" \
  -filter_complex "${filter_complex}" \
  -c:a "copy" \
  "${output_path}"

echo "${output_path}"
