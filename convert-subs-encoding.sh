#!/bin/bash
#
# Converts subs encoding.

find . -type f -name "*.srt" \
| while read -r path; do
    iconv \
      -f "WINDOWS-1251" \
      -t "UTF-8" \
      "${path}" \
      -o "${path}.converted"

    cp "${path}" "${path}.bak"
    rm -f "${path}"
    mv "${path}.converted" "${path}"
  done
