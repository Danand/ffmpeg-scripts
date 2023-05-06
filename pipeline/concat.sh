#!/bin/bash
#
# Glues videos from paths given via pipe.
# Returns path of output video.

set -e

SRC_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

source "${SRC_DIR}/utils.sh"

input_paths="$(cat)"
output_name="$1"

output_path="./outputs/${output_name}.mp4"

inputs_list_path="$(mktemp)"

IFS=$'\n'
for input_path in ${input_paths}; do
  echo "file '"$(realpath "${input_path}")"'" >> "${inputs_list_path}"

  duration="$(\
    ffprobe \
      -v "error" \
      -show_entries "format=duration" \
      -of "default=noprint_wrappers=1:nokey=1" \
      -sexagesimal \
      "${input_path}")"

  echo "inpoint 0:00:00.000000" >> "${inputs_list_path}"
  echo "outpoint ${duration}" >> "${inputs_list_path}"
done
unset IFS

cat "${inputs_list_path}"

rm -f "${output_path}"

ffmpeg \
  -f "concat" \
  -safe 0 \
  -i "${inputs_list_path}" \
  -c "copy" \
  "${output_path}"

rm -f "${inputs_list_path}"

echo "${output_path}"
