session="primary"

tmux ls | grep $session

if [ $? -eq 0 ]; then
	tmux attach -t $session
	exit 0
fi

tmux new-session -d -s $session

window=0
tmux rename-window -t $session:$window 'main'

window=1
tmux new-window -t $session:$window -n 'monitors'
tmux splitw -t primary:1.0 -vf
tmux splitw -t primary:1.0 -hf
tmux send-keys -t $session:$window.2 'htop' Enter
tmux send-keys -t $session:$window.1 'netstat -a' Enter

tmux select-window -t $session:0
tmux attach-session -t $session
