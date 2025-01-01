### TODO
Setup SSH keys from 1Password
###

# Install brew
if ! command -v brew &>/dev/null; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	echo "Brew already installed skipping."
fi

# Get dotfiles
if [[ ! -d "$HOME/dotfiles" ]]; then
	git clone https://github.com/scottfwalter/dotfiles.git ~/dotfiles
else
	echo "~/dotfiles exists, pulling latest."
	git pull
fi

# Initialize Dot Files
if ! command -v brew &>/dev/null; then
	brew install stow
else
	echo "Stow already installed skipping."
fi

/opt/homebrew/bin/stow -d ~/dotfiles -t ~/ bash bin brew config csh duckdns finicky git prettier sh ssh tcsh tmux vim zsh


# Install packages
#brew bundle --global

# create LaunchAgents dir
mkdir -p ~/Library/LaunchAgents

# Set up dock icons
echo "Setting up dock"
dockutil --remove all --no-restart
dockutil --add "/System/Applications/System Settings.app" --no-restart
dockutil --add "/Applications/Ghostty.app" --no-restart
dockutil --add "/Applications/Safari.app" --no-restart
dockutil --add "/Applications/Google Chrome.app" --no-restart
dockutil --add "/System/Applications/Messages.app" --no-restart
dockutil --add "/Applications/Spark Desktop.app" --no-restart
dockutil --add "/Applications/Obsidian.app" --no-restart
dockutil --add "/Applications/Todoist.app" --no-restart

# Folders to add to the dock
dockutil --add '/Applications' --view grid --display folder --no-restart
dockutil --add '/Users/scott/Library/Mobile Documents/com~apple~CloudDocs/MyDocuments' --view list --display folder --no-restart
dockutil --add '/Users/scott/Library/Mobile Documents/com~apple~CloudDocs/Downloads' --view list --display folder --no-restart

# Auto hide dock
#defaults write com.apple.dock autohide -bool true
#defaults write com.apple.dock autohide-delay -float 0
#defaults write com.apple.dock autohide-time-modifier -float 0
killall Dock

# xcode command line tools
xcode-select --install

# git config
echo "Setting up git"

#git config --global user.name "Mark R. Florkowski"
#git config --global user.email "mark.florkowski@gmail.com"
#git config --global core.editor "code --wait"
#git config --global push.default upstream

# commit signing with 1password
#git config --global user.signingkey "$(op item get "Github SSH Key" --fields "Public Key" --account RXTVLR6HMRES3CGS7G3WHSUPOQ)"
#git config --global gpg.format "ssh"
#git config --global gpg.ssh.program "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
#git config --global commit.gpgsign true

# git aliases
#git config --global alias.undo "reset --soft HEAD^"

# SSH Config
mkdir -p ~/.ssh
op read op://keys/"Jedi Temple Keys"/JediTemple-id_rsa -o ~/.ssh/id_rsa
op read op://keys/"Jedi Temple Keys"/JediTemple-id_rsa.pub -o ~/.ssh/id_rsa.pub

