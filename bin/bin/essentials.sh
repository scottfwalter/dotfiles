#! /bin/bash

results=$(mdfind -onlyin /Volumes/Media\ 02/ 'kMDItemUserTags = "*essential*"')
# readarray -t y <<<"$results"



IFS=$'\n' read -d '' -r -a bar <<<"$results"
#echo ${bar[1]}


mkdir -p /Users/scott/Library/Mobile\ Documents/com~apple~CloudDocs/essentials/
for i in "${bar[@]}"
do
	echo "$i"
  cp "$i" /Users/scott/Library/Mobile\ Documents/com~apple~CloudDocs/essentials/
done

