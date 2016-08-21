#!/bin/bash

set -eux

# Change to where this script is
HERE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
export GOPATH="$HERE"
cd "$HERE"

# Which programs to run
: ${TERMINAL:=roxterm --geometry=90x10 -d "$HERE" --zoom=0.75 --separate -e}
: ${NGINX:=nginx}
: ${PLAYER:=mpv}

# Run process in background, in its own terminal
function spawn() {
    $TERMINAL "/bin/sh -c 'NGINX=\"$NGINX\" PLAYER=\"$PLAYER\" $0 $@'" 2>/dev/null >/dev/null &
}

# No parameters given?
if [ -z "${1:-}" ] ; then

    # On exit, kill subprocesses
    trap "jobs -p | xargs kill -9" SIGHUP SIGINT SIGTERM

    # Install autotee and dependencies
    go get github.com/fxkr/autotee

    # Run individual components
    killall nginx ||: # TODO why doesn't it die by itself?
    spawn autotee
    spawn nginx
    spawn source

    wait
    exit
fi

# Individual subcommands
case "$1" in
    source)
        while [ true ] ; do
          ffmpeg -y -re -f lavfi -i testsrc2=duration=99999999:size=640x480:rate=30 -f flv rtmp://localhost:1935/stream/demo.mp4 ||:
          sleep 0.1
        done
        ;;
    nginx)
        exec $NGINX -c "$(realpath nginx.conf)"
        ;;
    autotee)
        exec go run src/github.com/fxkr/autotee/autotee.go autotee.yml
        ;;
esac

