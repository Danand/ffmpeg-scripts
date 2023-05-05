#!/bin/env python

import env
import os
import io
import sys
import subprocess
import time
import json

from typing import Dict, List

from pynput import keyboard

Markers = Dict[str, List[int]]

cwd: str = os.path.dirname(os.path.realpath(sys.argv[0]))
file_path: str = sys.argv[1]
markers_path: str = sys.argv[2]

current_frame = 0

def load_markers(path: str) -> Markers:
    if not os.path.exists(path):
        return {}

    with io.open(path, 'r') as file:
        text = file.read()

        if len(text) == 0:
            return {}

        obj = json.loads(text)

        return obj

def save_markers(path: str, obj: Markers) -> None:
    with io.open(path, 'w+') as file:
        text = json.dumps(obj)
        file.write(text)

markers: Markers = load_markers(markers_path)

process = subprocess.Popen(
    args=['/bin/bash', './ffplay-seek.sh', file_path],
    stdout=subprocess.PIPE,
    cwd=cwd)

def add_marker() -> None:
    print(f'Add marker at frame {current_frame}')
    markers_list = markers.pop(file_path, [])
    markers_list.append(current_frame)
    markers[file_path] = markers_list

listener = keyboard.GlobalHotKeys({
    '<ctrl>+m': add_marker
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
