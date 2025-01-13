#! /bin/bash

set -x

if [ $# -eq 0 ]; then
    echo "Error: Please provide a URL string as an argument"
    exit 1
fi

#TOKEN=$(op item get "Github (Nice)" --fields "Access Token")
#URL=$(echo "$1" | sed "s|//|//scottwalter-nice:$TOKEN@|")

URL="${1/https:\/\/github.com\//github-work:}"
#echo $URL
git clone $URL
