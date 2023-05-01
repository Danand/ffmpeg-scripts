# My scripts for working with `ffmpeg`

## Contents

* `speed-frames` — Python module for combining frames of several input videos into one output video, with increasing changing rate of frames
* `pipeline` — Bash scripts for building pipeline (or using standalone) of filters of my choice

## Usage

### `speed-frames`

```bash
cd speed-frames

python -m venv .venv
source .venv/bin/activate

pip install -r requirements.txt

python -m speed_frames $(ls -1 ~/Downloads/PXL_*)
```

### `pipeline`

```bash
cd pipeline

echo "source.mp4" | \
  ./change-speed.sh 0.5 | \
  ./add-subs.sh "subs.srt" | \
  apply-vhs-blurry.sh
```
