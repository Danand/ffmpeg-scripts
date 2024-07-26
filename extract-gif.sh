#!/usr/bin/env bash
#
# Extracts `.gif` from video.

input_file_path="$1"
timecode_from="$2"
duration="$3"

input_name_without_extension=$(basename "$input_file_path" | sed 's/\.[^.]*$//')

timecode_from_escaped=$(echo "$timecode_from" | tr ':' '_')

output_file_path="${input_name_without_extension}-${timecode_from_escaped}-${duration}.gif"

palette_path="palette.png"

filters="fps=10,scale=640:-1:flags=lanczos"

ffmpeg \
  -v warning \
  -ss "${timecode_from}" \
  -t "${duration}"\
  -i "${input_file_path}" \
  -vf "${filters},palettegen" \
  -y \
  "${palette_path}"

ffmpeg \
  -ss "${timecode_from}" \
  -i "${input_file_path}"  \
  -t "${duration}" \
  -vf "${filters}" \
  -gifflags \
  -transdiff \
  "${output_file_path}"

rm -f "${palette_path}"
