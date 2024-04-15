#!/bin/bash

SSH_DIR="$HOME/.ssh"

xcode-select --instal

if ! [ -x "$(command -v brew)" ]; then
	echo "installing brew..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! [[ -f "$SSH_DIR/id_rsa" ]]; then
	mkdir -p "$SSH_DIR"

	chmod 700 "$SSH_DIR"

	ssh-keygen -b 4096 -t rsa -f "$SSH_DIR/id_rsa" -N "" -C "$USER@$HOSTNAME"

	cat "$SSH_DIR/id_rsa.pub" >>"$SSH_DIR/authorized_keys"

	chmod 600 "$SSH_DIR/authorized_keys"
fi

./brew-formula.sh
./brew-cask.sh
./macos-config.sh
