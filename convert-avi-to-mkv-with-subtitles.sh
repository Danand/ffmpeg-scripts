#!/bin/bash
# Converts `.avi` to `.mkv` and adds subtitles.

CONVERTED_DIRECTORY="./converted"

input_file="$(find . -type f -name "*.avi" | sort | fzf --header "Choose video file")"
subtitles_file="$(find . -type f -name "*.srt" | sort | fzf --header "Choose subtitles file")"

if [ -z "${input_file}" ] || [ -z "${subtitles_file}" ]; then
  exit 0
fi

filename="${input_file##*/}"
filename_without_extension="${filename::-4}"

mkdir -p "${CONVERTED_DIRECTORY}"

ffmpeg \
  -i "${input_file}" \
  -i "${subtitles_file}" \
  -map 0:v \
  -map 0:a:1 \
  -map 1 \
  -c:v libx264 \
  -c:a aac \
  -scodec srt \
  -preset ultrafast \
  -profile:v high \
  -level:v 4.1 \
  -pix_fmt yuv420p \
  -flags global_header \
  "${CONVERTED_DIRECTORY}/${filename_without_extension}.mkv"
