#!/usr/bin/env bash
#
# Extracts `.gif` from video.

if [ "$1" = "--help" ]; then
  echo "Extracts a \`.gif\` from the specified video file using \`ffmpeg\`."
  echo
  echo "Usage:"
  echo "  extract-gif.sh <input_file_path> <timecode_from> <duration>"
  echo
  echo "Arguments:"
  echo "  <input_file_path>    Path to the input video file."
  echo "  <timecode_from>      Start time in the video (format: HH:MM:SS)."
  echo "  <duration>           Duration of the GIF (in seconds)."
  echo

  exit 0
fi

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
