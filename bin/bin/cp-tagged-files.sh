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

mkdir -p "$2"

input_string="$1"
read -ra arr <<<"$input_string"
for word in "${arr[@]}"; do
  if [[ -z $combined ]]; then
    combined+="kMDItemUserTags == '$word'"
  else
    combined+=" && kMDItemUserTags == '$word'"
  fi

done

mdfind "$combined" | xargs -n 1 -L 1 -t -I {} cp "{}" "$2"
#mdfind "$combined" | xargs -n 1 -L 1 -t -I {} cp "{}" $2 2>/dev/null

find "$2" -type f -print0 | while IFS= read -r -d '' file; do
  xattr -w com.apple.metadata:_kMDItemUserTags '<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd"><plist version="1.0"><array/></plist>' "$file"
done
