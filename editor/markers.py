import os
import io
import json

from aliases import Markers

def load_markers(path: str) -> Markers:
    if not os.path.exists(path):
        return {}

    with io.open(path, 'r') as file:
        text = file.read()

        if len(text) == 0:
            return {}

        markers = json.loads(text)

        return markers

def save_markers(path: str, markers: Markers) -> None:
    with io.open(path, 'w+') as file:
        text = json.dumps(markers)
        file.write(text)

def add_marker(markers: Markers, file_path: str, frame: int) -> None:
    print(f'Add marker at frame {frame}')

    frames = markers.pop(file_path, [])
    frames.append(frame)

    markers[file_path] = frames
