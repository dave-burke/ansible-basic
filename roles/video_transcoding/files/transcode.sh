#!/bin/bash

set -e

if [[ $# -eq 0 ]]; then
    cat <<EOF
Usage: $0 [TYPE] [transcode-video options] [FILENAME]

Types:

    --animation   = --filter nlmeans=medium --filter nlmeans-tune=animation
    --cgi         = --filter nlmeans=light
    --film        = --filter nlmeans=light --filter nlmeans-tune=film
    --grain       = --filter nlmeans=light --filter nlmeans-tune=grain
    --bsg         = --filter nlmeans=light --filter nlmeans-tune=highmotion
    --kid-tablets = --quick --filter nlmeans=light --avbr --target 500 --max-width 1024 --max-height 600 --audio-width all=stereo
    [default]     = --filter nlmeans=light

Common transcode-video options are:

Output options:
-o, --output FILENAME|DIRECTORY
                    set output path and filename, or just path
-n, --dry-run       don't transcode, just show `HandBrakeCLI` command and exit

Quality options:
    --avbr          use average variable bitrate (AVBR) ratecontrol
                      (size near target with different quality than default)
    --target big|small
    --target [2160p=|1080p=|720p=|480p=]BITRATE
                    set video bitrate target (default: based on input)
                      or target for specific input resolution
    --quick         increase encoding speed by 70-80% with no easily perceptible loss in video quality

Video options:
    --720p          fit video within 1280x720 pixel bounds
    --max-width WIDTH, --max-height HEIGHT
                    fit video within horizontal and/or vertical pixel bounds
Audio options:
    --add-audio TRACK[=NAME]|LANGUAGE[,LANGUAGE,...]|all
                    add track selected by number assigning it an optional name

Subtitle options:
    --burn-subtitle TRACK|scan
                    burn track selected by number into video
    --force-subtitle TRACK|scan
                    add track selected by number and set forced flag
    --add-subtitle TRACK|LANGUAGE[,LANGUAGE,...]|all
                    add track selected by number
    --no-auto-burn  don't automatically burn first forced subtitle

Requires `HandBrakeCLI`, `mp4track`, `ffmpeg` and `mkvpropedit`.

EOF
fi

if command -v realpath > /dev/null; then
	dir=$(dirname $(realpath ${0}))
else
	dir="$(cd $(dirname ${0}); pwd)"
fi

ARGS="--filter decomb "

case $1 in
	--animation)
		ARGS+="--filter nlmeans-tune=animation --filter nlmeans=medium"
		shift
		;;
	--cgi)
		ARGS+="--filter nlmeans=light"
		shift
		;;
	--film)
		ARGS+="--filter nlmeans=light --filter nlmeans-tune=film"
		shift
		;;
	--grain)
		ARGS+="--filter nlmeans=light --filter nlmeans-tune=grain"
		shift
		;;
	--bsg)
		ARGS+="--filter nlmeans=light --filter nlmeans-tune=highmotion"
		shift
		;;
    --kid-tablets)
		ARGS+="--quick --filter nlmeans=light --avbr --target 500 --max-width 1024 --max-height 600 --audio-width all=stereo"
		shift
		;;
	*)
		ARGS+="--filter nlmeans=light"
		#don't shift, $1 is still relevant
		;;
esac

echo "transcode-video ${ARGS} ${@}"
"transcode-video" ${ARGS} "${@}"

