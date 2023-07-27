#!/bin/bash
#
# Converts video to format supported by Samsung TV.

function convert_mkv() {
  input_file="$1"

  filename="${input_file##*/}"

  if [ -z "$2" ]; then
    output_file="./converted/${filename}"
  else
    output_file="./converted/$2"
  fi

  ffmpeg \
    -f matroska \
    -i "${input_file}" \
    -c:v libx264 \
    -preset ultrafast \
    -profile:v high \
    -level:v 4.1 \
    -pix_fmt yuv420p \
    -flags global_header \
    -c:a aac \
    "${output_file}"
}

function convert_avi() {
  input_file="$1"

  filename="${input_file##*/}"

  ffmpeg \
    -fflags +genpts \
    -i "${input_file}" \
    -c:v copy \
    -c:a copy \
    "./converted/${filename::-4}-tmp.mkv"
}

function convert() {
  input_file="$1"

  echo "Begin converting ${input_file}"

  filename="${input_file##*/}"

  if [[ $filename == *.mkv ]]; then
    convert_mkv "${input_file}"
  elif [[ $filename == *.avi ]]; then
    convert_avi "${input_file}"
    convert_mkv "./converted/${filename::-4}-tmp.mkv" "${filename::-4}.mkv"
    rm -f "./converted/${filename::-4}-tmp.mkv"
  else
    echo "Unsupported format of file: ${filename}"
  fi
}

function batch_convert() {
  shopt -s nullglob

  for input_file in *.{mkv,avi}; do
    convert "${input_file}" &
  done

  wait

  shopt -u nullglob
}

mkdir "./converted" 2>/dev/null

if [ -z "$1" ]; then
  batch_convert
else
  convert "$1"
fi

echo "Done"
