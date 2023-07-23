#!/bin/bash
#
# Applies audio to given input video path since given seconds.
# Trims excess audio duration
# Returns path of output video.

set -e

SRC_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

source "${SRC_DIR}/utils.sh"

input_path="$(cat)"
input_name="$(echo "${input_path}" | basename "$(cat)" | strip_extension "$(cat)")"

audio_path="$1"
audio_start_seconds="$2"

audio_name="$(echo "${audio_path}" | basename "$(cat)" | strip_extension "$(cat)")"

temp_audio_file_name="tmp-audio.m4a"
temp_audio_trimmed_file_name="tmp-audio-trimmed.m4a"

rm -f "${temp_audio_file_name}"
rm -f "${temp_audio_trimmed_file_name}"

# Extract audio from the video
ffmpeg \
  -i "${input_path}" \
  -vn \
  -c:a "copy" \
  "${temp_audio_file_name}"

# Trim the audio clip from the given starting seconds
audio_duration_trimmed="$(\
  ffprobe \
    -v "error" \
    -show_entries "format=duration" \
    -of "default=noprint_wrappers=1:nokey=1" \
    "${audio_path}" \
)"

ffmpeg \
  -ss "${audio_start_seconds}" \
  -i "${audio_path}" \
  -t "${audio_duration_trimmed}" \
  -c "copy" \
  "${temp_audio_trimmed_file_name}"

video_duration="$( \
  ffprobe \
    -v "error" \
    -show_entries "format=duration" \
    -of "default=noprint_wrappers=1:nokey=1" \
    "${input_path}" \
)"

final_duration="$( \
  echo "${video_duration} ${audio_start_seconds} ${audio_duration_trimmed}" \
  | awk '{ print $1-$2+$3 }' \
)"

output_path="./outputs/${input_name}-${audio_name}-${audio_start_seconds}.mp4"

rm -f "${output_path}"

ffmpeg \
  -i "${input_path}" \
  -i "${temp_audio_trimmed_file_name}" \
  -c:v "copy" \
  -map "0:v:0" \
  -map "1:a:0" \
  -t "$final_duration" \
  -shortest "${output_path}"

rm -f "${temp_audio_file_name}"
rm -f "${temp_audio_trimmed_file_name}"

echo "${output_path}"
