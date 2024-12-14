#!/bin/bash

# NODE_COMMAND=`which node`
# echo "$NODE_COMMAND"
# eval "$NODE_COMMAND /Users/scott/Dropbox/bin/tz/meeting-time.js $KMVAR_time"
#/usr/local/bin/node /Users/scott/Dropbox/bin/tz/meeting-time.js "$KMVAR_time"
#/Users/scott/.nvm/versions/node/v14.17.0/bin/node /Users/scott/bin/tz/meeting-time.js "$KMVAR_time"
# /Users/scott/.nvm/versions/node/v10.16.0/bin/node /Users/scott/Dropbox/bin/tz/meeting-time.js "10:00" "am"
# /Users/scott/.nvm/versions/node/v10.16.0/bin/node /Users/scott/Dropbox/bin/tz/meeting-time.js

NODE_COMMAND=`which node`
#node /Users/scott/bin/tz/meeting-time.js "$KMVAR_time"
eval "$NODE_COMMAND /Users/scott/bin/tz/meeting-time.js $KMVAR_time"
