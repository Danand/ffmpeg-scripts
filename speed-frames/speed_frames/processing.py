
from typing import List, Dict
from os import makedirs, path
from shutil import copyfile, rmtree
from natsort import os_sorted
from glob import glob
from pathlib import Path

from ffmpeg.ffprobe import get_frame_count
from ffmpeg.common import dump_frames, video_from_frames

from utils import math

def execute(
        initial_rate: int,
        final_rate: int,
        framerate: int,
        frame_extension: str,
        working_directory: str,
        output: str,
        files: List[str]):
    frame_counts = [get_frame_count(file) for file in files]
    frames_max = max(frame_counts)
    frames_digits = len(str(frames_max))

    for file in files:
        input_name = Path(file).stem

        dump_frames(
            file,
            frame_extension,
            f'{working_directory}/{input_name}',
            frames_digits,
            framerate)

    frames_to_videos: Dict[str, List[str]] = {}

    for file in files:
        input_name = Path(file).stem
        frames_to_videos[input_name] = os_sorted(glob(f'{working_directory}/{input_name}/*.{frame_extension}'))

    frames_to_videos = {key_value[0]: key_value[1] for key_value in sorted(frames_to_videos.items(), key = lambda item: len(item[1]))}

    selected_frames = []

    frame_count = 0

    while frame_count < frames_max:
        for frames in frames_to_videos.values():
            progress = frame_count / float(frames_max)
            change_rate = int(math.lerp(initial_rate, final_rate, progress))

            for _ in range(change_rate):
                if len(frames) > frame_count:
                    selected_frames.append(frames[frame_count])
                    frame_count += 1

    intermediate_directory = f'{working_directory}/intermediate'

    if path.exists(intermediate_directory):
        rmtree(intermediate_directory)

    makedirs(intermediate_directory, exist_ok=True)

    for selected_frame in selected_frames:
        copyfile(selected_frame, f'{intermediate_directory}/{path.basename(selected_frame)}')

    video_from_frames(frame_extension, intermediate_directory, output, framerate)
