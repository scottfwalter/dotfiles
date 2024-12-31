# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Get dotfiles
git clone https://github.com/scottfwalter/dotfiles.git ~/dotfiles

# Initialize Dot Files
brew install stow
/opt/homebrew/bin/stow -d ~/dotfiles -t ~/ bash bin brew config csh duckdns finicky git prettier sh ssh tcsh tmux vim zsh

# Install packages
brew bundle --global

# create LaunchAgents dir
mkdir -p ~/Library/LaunchAgents

# Set up dock icons
echo "Setting up dock"
dockutil --remove all --no-restart
dockutil --add "/Applications/Arc.app" --no-restart
dockutil --add "/Applications/Visual Studio Code.app" --no-restart
dockutil --add "/System/Applications/Utilities/Terminal.app" --no-restart
dockutil --add "/Applications/Discord.app" --no-restart
dockutil --add "/System/Applications/Messages.app" --no-restart
dockutil --add "/System/Applications/Notes.app" --no-restart
dockutil --add "/System/Applications/Utilities/Activity Monitor.app" --no-restart
dockutil --add "/System/Applications/System Settings.app" --no-restart

# Folders to add to the dock
dockutil --add '/Applications' --view grid --display folder --no-restart
dockutil --add '~/Documents' --view list --display folder --no-restart
dockutil --add '~/Downloads' --view list --display folder

# Auto hide dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
killall Dock

# xcode command line tools
xcode-select --install

# git config
echo "Setting up git"

git config --global user.name "Mark R. Florkowski"
git config --global user.email "mark.florkowski@gmail.com"
git config --global core.editor "code --wait"
git config --global push.default upstream

# commit signing with 1password
git config --global user.signingkey "$(op item get "Github SSH Key" --fields "Public Key" --account RXTVLR6HMRES3CGS7G3WHSUPOQ)"
git config --global gpg.format "ssh"
#git config --global gpg.ssh.program "/Applications/1Password.app/Contents/MacOS/op-ssh-sign"
git config --global commit.gpgsign true

# git aliases
git config --global alias.undo "reset --soft HEAD^"

