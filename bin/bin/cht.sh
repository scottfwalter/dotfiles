#!/usr/bin/env /opt/homebrew/bin/bash
#!/usr/bin/env /bin/zsh

#!/usr/bin/env bash
languages=$(echo "golang lua cpp c javascript typescript nodejs" | tr ' ' '\n')
core_utils=$(echo "xargs find mv sed awk" | tr ' ' '\n')

selected=$(printf "$languages\n$core_utils" | fzf)

read -p "Enter Query: " query
#read "query?Enter Query: "

if echo $languages | grep -qs $selected; then

	curl cht.sh/$selected/$(echo $query | tr ' ' '+')
else
	curl cht.sh/$selected~$(echo $query | tr ' ' '+')
fi

##!/usr/bin/env bash
#selected=`cat ~/.tmux-cht-languages ~/.tmux-cht-command | fzf`
#if [[ -z $selected ]]; then
#    exit 0
#fi
#
#
#if grep -qs "$selected" ~/.tmux-cht-languages; then
#    query=`echo $query | tr ' ' '+'`
#    tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query & while [ : ]; do sleep 1; done"
#else
#    tmux neww bash -c "curl -s cht.sh/$selected~$query | less"
#fi
