#!/bin/env python

import env
import os
import io
import sys
import subprocess
import time

from pynput import keyboard

from aliases import Markers
from markers import load_markers, save_markers, add_marker

cwd: str = os.path.dirname(os.path.realpath(sys.argv[0]))
file_path: str = sys.argv[1]
markers_path: str = sys.argv[2]

current_frame = 0

markers: Markers = load_markers(markers_path)

SEEK_INTERVAL: str = env.get("SEEK_INTERVAL")

process = subprocess.Popen(
    args=['/bin/bash', './ffplay-seek.sh', file_path, '-seek_interval', SEEK_INTERVAL],
    stdout=subprocess.PIPE,
    cwd=cwd)

listener = keyboard.GlobalHotKeys({
    '<ctrl>+m': lambda: add_marker(markers, file_path, current_frame)
})

listener.start()

FRAME_NUMBER_PATH: str = env.get("FRAME_NUMBER_PATH")

while not os.path.exists(FRAME_NUMBER_PATH):
    time.sleep(1)

with io.open(FRAME_NUMBER_PATH, 'r') as file:
    while True:
        exit_code = process.poll()

        if exit_code is not None:
            print(f'ffplay exited with code: {exit_code}')
            break

        if not file.readable():
            continue

        file.seek(0)

        line = file.readline().strip()

        if line is not None and len(line) > 0:
            current_frame = int(line)

os.remove(FRAME_NUMBER_PATH)

save_markers(markers_path, markers)
