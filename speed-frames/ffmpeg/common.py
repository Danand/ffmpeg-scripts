import subprocess

from os import makedirs, path
from shutil import rmtree

def dump_frames(
    input: str,
    output_extension: str,
    output_directory: str,
    frames_digits: int,
    framerate: int) -> None:

    output = f'{output_directory}'

    if path.exists(output):
        rmtree(output)

    makedirs(output, exist_ok=True)

    subprocess.check_call(
        [
            'ffmpeg',
            '-i',
            input,
            '-r',
            f'{framerate}/1',
            f'{output}/%0{frames_digits}d.{output_extension}',
        ])

def video_from_frames(
        input_extension: str,
        input_directory: str,
        output: str,
        framerate: int):
    input_glob = f'{input_directory}/*.{input_extension}'

    subprocess.check_call(
        [
            'ffmpeg',
            '-framerate',
            str(framerate),
            '-pattern_type',
            'glob',
            '-i',
            input_glob,
            '-c:v',
            'libx264',
            '-pix_fmt',
            'yuv420p',
            output,
        ])
