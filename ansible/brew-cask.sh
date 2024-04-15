#!/bin/bash

echo -e "Installing brew casks..."

while read p; do
	echo $p

	#rc=$(brew list --casks $p >/dev/null 2>&1)
	#echo "$p with $?"

	if ! $(brew list --casks $p >/dev/null 2>&1); then
		brew install --cask --appdir="/Applications" $p
	else
		echo "Skipping $p  as its already installed"
	fi

done <./brew-cask.lst
