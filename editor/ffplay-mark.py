#!/bin/env python

import env
import os
import io
import sys
import subprocess
import time

from pynput import keyboard

cwd = os.path.dirname(os.path.realpath(sys.argv[0]))
file_path = sys.argv[1]

current_frame = 0

markers = []

def add_marker():
    print(f'Add marker at frame {current_frame}')
    markers.append(current_frame)

process = subprocess.Popen(
    args=['/bin/bash', './ffplay-seek.sh', file_path],
    stdout=subprocess.PIPE,
    cwd=cwd)

listener = keyboard.GlobalHotKeys({
    '<ctrl>+m': add_marker
})

listener.start()

FRAME_NUMBER_PATH = env.get("FRAME_NUMBER_PATH")

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

print(markers)
