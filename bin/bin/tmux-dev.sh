#!/bin/sh

session="dev"
tmux ls | grep $session

if [ $? -eq 0 ]; then
	tmux attach -t $session
	exit 0
fi

window=0
tmux new-session -d -s $session
tmux rename-window -t $session:$window 'main'
tmux select-window -t $session:0
tmux attach-session -t $session
