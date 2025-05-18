#!/bin/bash

DIR="$1"
shift
CMD="$@"

printUsage() {
    echo "Usage: $0 <directory> <command>"
}

if [[ -z "$DIR" || -z "$CMD" ]]; then
    printUsage
    exit 1
fi

process_pid=""
cleaned_up=0

kill_existing() {
    if [[ -n "$process_pid" ]] && kill -0 "$process_pid" 2>/dev/null; then
        echo "Stopping server (PID $process_pid)"
        kill "$process_pid"
        wait "$process_pid" 2>/dev/null
    fi
}

cleanup() {
    if [[ $cleaned_up -eq 0 ]]; then
        cleaned_up=1
        kill_existing
        echo "\n"
        echo "Cleanup complete"
    fi
}

trap cleanup EXIT INT TERM

run_command() {
    kill_existing
    clear
    echo "Running: $CMD"
    bash -c "$CMD" &
    process_pid=$!
}

watchMacos() {
    run_command
    fswatch -0 "$DIR" | while read -d "" event; do
        run_command
    done
}

watchLinux() {
    run_command
    while read event; do
        run_command
    done < <(inotifywait -m -e modify,create,delete,move --format '%w%f' --quiet "$DIR")
}

printUnsupportedOSMsg() {
    echo "Unsupported OS"
    exit 2
}

clear
if [[ "$(uname)" == "Darwin" ]]; then
    watchMacos
elif [[ "$(uname)" == "Linux" ]]; then
    watchLinux
else
    printUnsupportedOSMsg
fi
