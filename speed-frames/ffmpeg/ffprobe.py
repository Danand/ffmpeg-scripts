import subprocess

def get_frame_count(input: str) -> int:
    output: str = subprocess.check_output(
        [
            'ffprobe',
            '-v',
            'error',
            '-select_streams',
            'v:0',
            '-count_packets',
            '-show_entries',
            'stream=nb_read_packets',
            '-of',
            'csv=p=0',
            input,
        ]).decode()

    return int(output)