#!/bin/zsh

DOTFILES_DIR="$HOME/Dropbox/.dotfiles"
SSH_DIR="$HOME/.ssh"

if ! [ -x "$(command -v ansible)" ]; then
 brew install ansible
fi
