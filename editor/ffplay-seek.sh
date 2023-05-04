#!/bin/bash
#
# Outputs current frame of running `ffplay` to file `/tmp/ffplay-frame`.

set -o allexport
source ./.env
set +o allexport

cat /dev/null > "${FRAME_NUMBER_PATH}"

ffplay -vf "showinfo" "$1" 2>&1 | while read line; do
  current_frame="$(echo "${line}" | grep -oP "n:\s+\K\d+")"

  if [ -z "${current_frame}" ]; then
    continue
  fi

  echo "${current_frame}" > "${FRAME_NUMBER_PATH}"
done
