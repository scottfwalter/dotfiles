#!/bin/bash

echo -e "Installing brew formulas..."

while read p; do
	package=$(echo "$p" | cut -d ":" -f 1)
	command=$(echo "$p" | cut -d ":" -f 2)

	if [[ ! "$package" == "$command" ]]; then
		check_command=$command
	else
		check_command=$package
	fi

	echo "$check_command"

	if ! [ -x "$(command -v $check_command)" ]; then
		echo "installing $p..."
                brew install $check_command
	fi

done <./brew-formula.lst
