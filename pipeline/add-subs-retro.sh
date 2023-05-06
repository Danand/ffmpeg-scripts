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

video_filter="\
  subtitles=${subtitles_path} \
    :force_style='\
      Fontname=Arial, \
      Fontsize=16, \
      PrimaryColour=&H03fcff, \
      Italic=1'"

rm -f "${output_path}"

ffmpeg \
  -i "${input_path}" \
  -vf "${video_filter}" \
  -c:a "copy" \
  "${output_path}"

echo "${output_path}"
