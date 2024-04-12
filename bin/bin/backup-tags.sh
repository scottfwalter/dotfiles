#! /bin/bash

echo "start $(date)" >> "/Users/scott/tmp/taglog.txt"
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

cd /Users/scott/Library/Mobile\ Documents/com~apple~CloudDocs/MyDocuments || exit
#find . -type d -prune -exec bash -c "cd \"{}\" && $SCRIPT_DIR/tagbak store " \;
find . -type d -exec bash -c "cd \"{}\" && $SCRIPT_DIR/tagbak store " \; >/dev/null 2>&1

cd /Volumes/Media\ 02 || exit
find "Videos - Design" -type d -exec bash -c "cd \"{}\" && $SCRIPT_DIR/tagbak store " \; >/dev/null 2>&1
find "Videos - Dev" -type d -exec bash -c "cd \"{}\" && $SCRIPT_DIR/tagbak store " \; >/dev/null 2>&1
find "Videos - Documentaries" -type d -exec bash -c "cd \"{}\" && $SCRIPT_DIR/tagbak store " \; >/dev/null 2>&1
find "Videos - Photography Courses" -type d -exec bash -c "cd \"{}\" && $SCRIPT_DIR/tagbak store " \; >/dev/null 2>&1
find "Videos - Photography Topics" -type d -exec bash -c "cd \"{}\" && $SCRIPT_DIR/tagbak store " \; >/dev/null 2>&1
find "Videos - Potpourri" -type d -exec bash -c "cd \"{}\" && $SCRIPT_DIR/tagbak store " \; >/dev/null 2>&1
find "Videos - Video Filming and Editing" -type d -exec bash -c "cd \"{}\" && $SCRIPT_DIR/tagbak store " \; >/dev/null 2>&1

echo "end $(date)" >> "/Users/scott/tmp/taglog.txt"