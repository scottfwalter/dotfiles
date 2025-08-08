# Here we go.. ask for the administrator password upfront and run a
# keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
done 2>/dev/null &

# Command Line utils
xcode-select --install

# Fast Node Manager (fnm)
if ! [ -x "$(command -v fnm)" ]; then
    curl -fsSL https://fnm.vercel.app/install | bash
    echo "Pleas reload shell and run this script again"
    exit 1
else
    fnm install --latest
fi

# Brew
if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew eval
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

/opt/homebrew/bin/stow -d ~/dotfiles -t ~/ bash bin brew config csh duckdns finicky git prettier sh ssh tcsh tmux vim zsh claude

# Install packages
brew bundle --global

echo -e "Installing npm packages..."

while read p; do
    npm install -g $p
done <./npm-packages.lst

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

# Dock Position
defaults write com.apple.dock "orientation" -string "right" && killall dock
#defaults write com.apple.dock "orientation" -string "left" && killall dock
#defaults write com.apple.dock "orientation" -string "bottom" && killall dock

# Dock Icon Size
defaults write com.apple.dock "tilesize" -int "48"

# Turn off auto hide
defaults write com.apple.dock "autohide" -bool "false"

# Don't display recent items
defaults write com.apple.dock "show-recents" -bool "false"

# Only show active icons in dock
defaults write com.apple.dock "static-only" -bool "false"

# Spring load folders in dock
defaults write com.apple.dock "enable-spring-load-actions-on-all-items" -bool "true"

##########
# Screenshots
##########

# Disable shadow
defaults write com.apple.screencapture "disable-shadow" -bool "true"

# Store screenshots on Desktop
defaults write com.apple.screencapture "location" -string "~/Desktop"

# Screenshot file format
defaults write com.apple.screencapture "type" -string "png"

##########
# Finder
##########

# Show all file extensions
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"

# Show path bar
defaults write com.apple.finder "ShowPathbar" -bool "true"

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Default view  type
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv" #list
#defaults write com.apple.finder "FXPreferredViewStyle" -string "clmv" #column
#defaults write com.apple.finder "FXPreferredViewStyle" -string "icnv" #icon

# Keep folders on top when sorting
defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"

# Set search scope to current folder
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"

# Don't warn when changing file extensions
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"

# Don't default to iCloud for new files
defaults write NSGlobalDomain "NSDocumentSaveNewDocumentsToCloud" -bool "false"

# Sidebar icon Size
#defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int "1"
#defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int "2"
defaults write NSGlobalDomain "NSTableViewDefaultSizeMode" -int "3"

# New Window Target
# Computer     : `PfCm`
# Volume       : `PfVo`
# $HOME        : `PfHm`
# Desktop      : `PfDe`
# Documents    : `PfDo`
# All My Files : `PfAF`
# Other…       : `PfLo`
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Disable disk image verification
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Show the ~/Library folder
sudo chflags nohidden ~/Library
# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 64" ~/Library/Preferences/com.apple.finder.plist

##########
# Desktop
##########

# Keep folders on top when sorting
defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool "true"

# Show hard drives
defaults write com.apple.finder "ShowHardDrivesOnDesktop" -bool "true"

# Show external drives
defaults write com.apple.finder "ShowExternalHardDrivesOnDesktop" -bool "true"

# Show removable media
defaults write com.apple.finder "ShowRemovableMediaOnDesktop" -bool "true"

# Show connected servers
defaults write com.apple.finder "ShowMountedServersOnDesktop" -bool "true"

# Disable hide windows on wallpaper click
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -int 0

##########
# Windows
##########
defaults write -g AppleWindowTilingMarginsEnabled -bool false
defaults write NSGlobalDomain AppleActionOnDoubleClick -string "Maximize"

##########
# Keyboard
##########

# Repeat key when held down
defaults write NSGlobalDomain "ApplePressAndHoldEnabled" -bool "false"

defaults write com.apple.dock "expose-group-apps" -bool "true"

##########
# Text Edit
##########

# Use plain text
defaults write com.apple.TextEdit "RichText" -bool "false"

##########
# Time Machine
##########

# Don't propt when new disks are added
defaults write com.apple.TimeMachine "DoNotOfferNewDisksForBackup" -bool "true"

##########
# Activity Monitor
##########

# Activity monitor update rate
defaults write com.apple.ActivityMonitor "UpdatePeriod" -int "2"

##########
# System Dialogs
##########

# expand save dialog
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# expand print dialog
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

##########
# Printer
##########

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# SSH Config
mkdir -p ~/.ssh

#op read op://keys/"Jedi Temple Keys"/JediTemple-id_rsa -o ~/.ssh/id_rsa
#op read op://keys/"Jedi Temple Keys"/JediTemple-id_rsa.pub -o ~/.ssh/id_rsa.pub

#if ! [[ -f "$SSH_DIR/id_rsa" ]]; then
#	chmod 700 "$SSH_DIR"
#	ssh-keygen -b 4096 -t rsa -f "$SSH_DIR/id_rsa" -N "" -C "$USER@$HOSTNAME"
#	cat "$SSH_DIR/id_rsa.pub" >>"$SSH_DIR/authorized_keys"
#	chmod 600 "$SSH_DIR/authorized_keys"
#fi

##########
# Finished
##########

for app in "Activity Monitor" \
    "Dock" \
    "Finder" \
    "Safari" \
    "SystemUIServer" \
    "TextEdit"; do
    killall "${app}" &>/dev/null
done

exit 0
