#!/usr/bin/env /opt/homebrew/bin/bash
#!/usr/bin/env /bin/zsh
#!/usr/bin/env zx

if [ -z "$1" ]
  then
    echo "No argument supplied"
fi

if [ "$1" ]
  then
    echo "argument supplied"
fi

name=${2:-hello world}
echo $name


ans=$1
if [[ "${ans}" == "n" || "${ans}" == "N" ]]; then
	printf "No\n"
fi

read -p "Enter your color: " color
color=${color:-blue}
echo $color

select color in "red" "green" "blue"; do
 echo "You selected $color"
 break
done
echo "hello $color"
