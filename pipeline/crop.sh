#!/bin/bash
#
# Crops video of given input video path using given width and height values.
# Returns cropped output video.

set -e

SRC_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

source "${SRC_DIR}/utils.sh"

input_path="$(cat)"
input_name="$(echo "${input_path}" | basename "$(cat)" | strip_extension "$(cat)")"

width_aspect="$1"
height_aspect="$2"

input_stream_info="$(\
  ffprobe \
    -v "error" \
    -select_streams "v:0" \
    -show_entries "stream=width,height:stream_tags=rotate" \
    -of "csv=p=0" \
    "${input_path}"\
)"

input_width="$(echo "${input_stream_info}" | cut -d "," -f 1)"
input_height="$(echo "${input_stream_info}" | cut -d "," -f 2)"
input_rotation="$(echo "${input_stream_info}" | cut -d "," -f 3)"

if [ "${input_rotation}" == "-90" ] || [ "${input_rotation}" == "90" ]; then
  eval "input_height="${input_width}"; input_width="${input_height}""
fi

if [ $input_width -gt $input_height ]; then
  output_width="$(echo "${input_width} * (${height_aspect} / ${width_aspect})" | bc -l)"
  output_height="${input_height}"
else
  output_width="${input_width}"
  output_height="$(echo "${input_width} * (${height_aspect} / ${width_aspect})" | bc -l)"
fi

output_path="./outputs/${input_name}-${width_aspect}x${height_aspect}.mp4"

rm -f "${output_path}"

ffmpeg \
  -i "${input_path}" \
  -filter:v "crop=${output_width}:${output_height}" \
  -c:a "copy" \
  "${output_path}"

echo "${output_path}"
