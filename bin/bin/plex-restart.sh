#! /bin/bash

ps -ef | grep "Plex Media Server" | grep -v grep | awk '{print $2}' | xargs kill -9
"/Applications/Plex Media Server.app/Contents/MacOS/Plex Media Server" &
