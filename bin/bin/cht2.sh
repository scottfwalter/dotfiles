#!/usr/bin/env /opt/homebrew/bin/bash
#!/usr/bin/env /bin/zsh

SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

selected=`cat $SCRIPTPATH/.commands.txt $SCRIPTPATH/.languages.txt | fzf`
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if grep -qs "$selected" ~/bin/languages.txt; then
    query=`echo $query | tr ' ' '+'`
    curl cht.sh/$selected/$query
else
    curl -s cht.sh/$selected~$query
fi
