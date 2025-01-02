#!/bin/bash

echo -e "Installing brew casks..."
echo "You should set sudo timeout length: sudo visudo"
sudo -v

while read p; do
	if [[ "$p" == \#* ]]; then
		echo "$p is commented out so skipping..."
		continue
	fi
	cask=$(echo "$p" | cut -d ":" -f 1)
   	applicationName=$(echo "$p" | cut -d ":" -f 2)

	if [ "$cask" != "$applicationName" ]; then
		echo "Checking $applicationName"
		if $(find /Applications -name "$applicationName*.app" -maxdepth 1 | grep . > /dev/null 2>&1); then
			echo "$cask as it already installed in /Applications, skipping..."
			continue
		fi
	fi

	if ! $(brew list --casks $p >/dev/null 2>&1); then
		brew install --cask --appdir="/Applications" $cask
	else
		echo "$p as its already installed, skipping..."
	fi
done <./brew-cask.lst

