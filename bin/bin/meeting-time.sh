#!/bin/bash

if [ $# -eq 0 ]; then
  echo "WTF1" >> ~/oops.txt
  if [ -n "$KMVAR_time" ]; then
    TIME=$KMVAR_time
  else
    echo "NO" >> ~/oops.txt
    TIME=$(date +"%I:%M %p")
  fi

else
  TIME=$1
fi

locations=(
    "Utah:America/Denver"
    "Santiago:America/Santiago"
    "Israel:Asia/Jerusalem"
    "Pune:Asia/Kolkata"
)

original_IFS="$IFS"
for location in "${locations[@]}"; do
    IFS=':'  # Set the Internal Field Separator to colon
    read location timezone <<< "$location"  # Split and store in variables
    value=$(TZ="$timezone" /opt/homebrew/bin/gdate --date="TZ=\"America/Chicago\" $TIME" "+%I:%M %p")
    result="${result} $location: $value |"
done

result=${result%?}
IFS=$original_IFS
echo $result
