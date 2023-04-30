if __name__ == "__main__":
    import argparse
    import sys

    from speed_frames.processing import execute

    argparser = argparse.ArgumentParser(
        'Speed Frames',
        'Takes frames from given videos and glues them up with increasing change rate')

    argparser.add_argument('--initial-rate',
                        type=int,
                        default=30,
                        help='Initial change rate, e.g. each 30 frames')

    argparser.add_argument('--final-rate',
                        type=int,
                        default=1,
                        help='Final change rate, e.g. each 1 frame')

    argparser.add_argument('--framerate',
                        type=int,
                        default=30,
                        help='Working framerate')

    argparser.add_argument('--frame-extension',
                        type=str,
                        default='bmp',
                        help='Frame file extension')

    argparser.add_argument('--working-directory',
                        type=str,
                        default='outputs',
                        help='Working directory for artifacts')

    argparser.add_argument('--output',
                        type=str,
                        default='out.mp4',
                        help='Output video file name')

    argparser.add_argument('files',
                        type=str,
                        help='Input files, space-separated',
                        nargs='+')

    args = argparser.parse_args(sys.argv[1:])

    execute(
        initial_rate=args.initial_rate,
        final_rate=args.final_rate,
        framerate=args.framerate,
        frame_extension=args.frame_extension,
        working_directory=args.working_directory,
        output=args.output,
        files=args.files)

