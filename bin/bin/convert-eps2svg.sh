#! /bin/bash

# Enable case-insensitive globbing
shopt -s nocaseglob

for FILE in "."/*.eps; do
  filename=$(basename "$FILE")
  #extension=${filename##*.}
  filename_noext=${filename%.*}
  #jjdestfile="$filename.$DEST_EXT"

  echo $filename
  echo $filename_noext

  inkscape -o "$filename_noext".svg "$filename"
done

# Disable case-insensitive globbing
shopt -u nocaseglob
