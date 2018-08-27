read -n1 -r -p "Press any key to continue..." key
clear
ssh aidan@10.240.20.10 -t "bash -ic 'tmux select-window -t $1:$2; tmux attach -t $1'"
