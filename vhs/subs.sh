#!/bin/bash
#
# Applies subtitles to given input video path.
# Returns path of output video.

set -e

source ./utils.sh

input="$(cat)"
subtitles_path="$1"
filename="$(basename "${input}")"
output="./outputs/$(strip_extension "${filename}")-subs.mp4"

filtergraph="subtitles=${subtitles_path}:force_style='Fontname=Arial,Fontsize=16,PrimaryColour=&H03fcff,Italic=1'"

ffmpeg \
  -i "${input}" \
  -vf "${filtergraph}" \
  -c:a copy \
  "${output}"

echo "${output}"
