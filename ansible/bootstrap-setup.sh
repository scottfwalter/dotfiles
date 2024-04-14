#!/bin/bash

DOTFILES_DIR="$HOME/dotfiles"
SSH_DIR="$HOME/.ssh"

echo "Make sure you increase sudo timeout"
echo "sudo visudo"
echo "Defaults    timestamp_timeout=120"

if ! [ -x "$(command -v brew)" ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! [ -x "$(command -v ansible)" ]; then
  brew install ansible
fi

if ! [[ -f "$SSH_DIR/id_rsa" ]]; then
  mkdir -p "$SSH_DIR"

  chmod 700 "$SSH_DIR"

  ssh-keygen -b 4096 -t rsa -f "$SSH_DIR/id_rsa" -N "" -C "$USER@$HOSTNAME"

  cat "$SSH_DIR/id_rsa.pub" >> "$SSH_DIR/authorized_keys"

  chmod 600 "$SSH_DIR/authorized_keys"
fi

if [[ -f "$DOTFILES_DIR/requirements.yml" ]]; then
  cd "$DOTFILES_DIR"

  ansible-galaxy install -r requirements.yml
fi

cd "$DOTFILES_DIR"
ansible-playbook "$DOTFILES_DIR/main.yml" --ask-become-pass --ask-vault-pass

echo "Make sure you reset sudo timeout"
echo "sudo visudo"
echo "Defaults    timestamp_timeout=120"

