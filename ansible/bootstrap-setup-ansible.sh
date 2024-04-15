#!/bin/bash

PLAYBOOK_DIR="$HOME/dotfiles/ansible"
SSH_DIR="$HOME/.ssh"

echo -e "Make sure you increase sudo timeout\n"
echo "sudo visudo"
echo -e "Defaults    timestamp_timeout=120\n\n"

if ! [ -x "$(command -v brew)" ]; then
  echo "installing brew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if ! [ -x "$(command -v ansible)" ]; then
  echo "installing ansible..."
  brew install ansible
fi


if ! [[ -f "$SSH_DIR/id_rsa" ]]; then
  mkdir -p "$SSH_DIR"

  chmod 700 "$SSH_DIR"

  ssh-keygen -b 4096 -t rsa -f "$SSH_DIR/id_rsa" -N "" -C "$USER@$HOSTNAME"

  cat "$SSH_DIR/id_rsa.pub" >> "$SSH_DIR/authorized_keys"

  chmod 600 "$SSH_DIR/authorized_keys"
fi

cd "$ANSIBLE_DIR"
if [[ -f "$/ansible/requirements.yml" ]]; then
  ansible-galaxy install -r requirements.yml
fi

ansible-playbook "main.yml" --ask-become-pass --ask-vault-pass

echo "Make sure you reset sudo timeout"
echo "sudo visudo"
echo "Defaults    timestamp_timeout=5"
