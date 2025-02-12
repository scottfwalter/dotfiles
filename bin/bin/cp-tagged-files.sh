#!/bin/bash

# Create the destination directory if it doesn't exist

if [ -z "$1" ]; then
  echo "No tags specified"
  exit 1
fi

if [ -z "$2" ]; then
  echo "No destination specified"
  exit search
fi

mkdir -p $2

input_string="$1"
#IFS=' ' read -ra words <<<"$input_string"
read -ra arr <<<"$input_string"
declare -a processed_strings
for word in "${arr[@]}"; do
  echo "wtf: $word"
  # Create the formatted string and add it to the array
  echo "kMDItemUserTags == '$word'"

  if [[ -z $combined ]]; then
    combined+="kMDItemUserTags == '$word'"
  else
    combined+=" && kMDItemUserTags == '$word'"
  fi

done

echo $combined

mdfind "$combined" |
  xargs -n 1 -L 1 -t -I {} cp "{}" ~/favs/

find $2 -type f -print0 | while IFS= read -r -d '' file; do
  xattr -w com.apple.metadata:_kMDItemUserTags '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><array/></plist>' "$file"
  echo "Removed tags from: $file"
done
