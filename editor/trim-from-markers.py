#!/bin/env python
#
# Performs trimming from marks `.json` file.
# Each file selected from marker key.
# Start frame for each file selected from marker value at index 0.
# End frame for each file selected from marker value at index 1.

import os
import sys
import subprocess

from aliases import Markers

from markers import load_markers

cwd: str = os.path.dirname(os.path.realpath(sys.argv[0]))
markers_path: str = sys.argv[1]
marker_index_from: int = int(sys.argv[2]) if len(sys.argv) > 2 else 0
marker_index_to: int = int(sys.argv[3]) if len(sys.argv) > 3 else 1

markers: Markers = load_markers(markers_path)

for file_path, frames in markers.items():
    subprocess.check_call(
      args=['/bin/bash', '-c', f'echo {file_path} | ../pipeline/trim.sh {frames[marker_index_from]} {frames[marker_index_to]}'],
      stdout=subprocess.PIPE,
      cwd=cwd)
