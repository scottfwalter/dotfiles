#!/bin/bash

if [ -z "$1" ]; then
  echo "No tags specified"
  exit 1
fi

input_string="$1"
read -ra arr <<<"$input_string"
for word in "${arr[@]}"; do
  if [[ -z $combined ]]; then
    combined+="kMDItemUserTags == '$word'"
  else
    combined+=" && kMDItemUserTags == '$word'"
  fi

done

mdfind "$combined"
