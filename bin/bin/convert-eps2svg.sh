#! /bin/bash

# Enable case-insensitive globbing
shopt -s nocaseglob
set -x

for FILE in "."/**/*.eps; do
  filename=$(basename "$FILE")
  #extension=${filename##*.}
  filename_noext=${filename%.*}
  #jjdestfile="$filename.$DEST_EXT"

  echo $filename
  echo $filename_noext

  inkscape -o "$filename_noext".svg "$FILE"
done

# Disable case-insensitive globbing
shopt -u nocaseglob
