#!/bin/bash

echo -e "Installing App Store Items..."

while read p; do
	id=$(echo "$p" | cut -d "," -f 1)
	name=$(echo "$p" | cut -d "," -f 2)

	if ! $(mas list | grep $id >/dev/null 2>&1); then
		echo "Installing $name"
		mas install $id
	else
		echo "Skipping $name as its already installed"
	fi

done <./appstore.lst
