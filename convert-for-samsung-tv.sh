#!/bin/bash
#
# Converts video to format supported by Samsung TV.

CONVERTED_DIRECTORY="./converted"

function convert_mkv() {
  local input_file="$1"
  local filename="${input_file##*/}"

  local output_file

  if [ -z "$2" ]; then
    output_file="${CONVERTED_DIRECTORY}/${filename}"
  else
    output_file="${CONVERTED_DIRECTORY}/$2"
  fi

  ffmpeg \
    -f matroska \
    -i "${input_file}" \
    -c:v libx264 \
    -c:a aac \
    -c:s srt \
    -preset ultrafast \
    -profile:v high \
    -level:v 4.1 \
    -pix_fmt yuv420p \
    -flags global_header \
    "${output_file}"
}

function convert_avi() {
  local input_file="$1"
  local filename="${input_file##*/}"
  local filename_without_extension="${filename::-4}"

  ffmpeg \
    -fflags +genpts \
    -i "${input_file}" \
    -c:v copy \
    -c:a copy \
    "${CONVERTED_DIRECTORY}/${filename_without_extension}-tmp.mkv"
}

function convert() {
  local input_file="$1"

  echo "Begin converting ${input_file}"

  local filename="${input_file##*/}"
  local filename_without_extension="${filename::-4}"

  if [[ $filename == *.mkv ]]; then
    convert_mkv "${input_file}"
  elif [[ $filename == *.avi ]]; then
    convert_avi "${input_file}"

    convert_mkv \
      "${CONVERTED_DIRECTORY}/${filename_without_extension}-tmp.mkv" \
      "${filename_without_extension}.mkv"

    rm -f "${CONVERTED_DIRECTORY}/${filename::-4}-tmp.mkv"
  else
    echo "Unsupported format of file: ${filename}" 1>&2
  fi
}

function batch_convert() {
  shopt -s nullglob

  for input_file in *.{mkv,avi}; do
    convert "${input_file}"
  done

  wait

  shopt -u nullglob
}

set -e

mkdir -p "${CONVERTED_DIRECTORY}"

if [ $# -eq 0 ]; then
  batch_convert
else
  convert "$1"
fi

echo "Done"
