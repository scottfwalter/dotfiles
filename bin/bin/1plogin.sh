#!/bin/zsh --no-rcs

id=$(op item create --category login \
  --title "$1" \
  --url "$1" \
  --generate-password \
  --vault "Personal"\
  username=scott@scottwalter.com | grep "^ID:" | cut -d':' -f2 | xargs)
  #username=scott@scottwalter.com)

op item get $id --fields password --reveal | pbcopy
