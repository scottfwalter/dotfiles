#!/usr/bin/env zsh

BREW_PREFIX=$(brew --repository)

###########################################
# Core Tools
###########################################

# brew install coreutils
brew install coreutils

# Tmux
brew install tmux

# MAS - Install App Store
brew install mas

# Stow
brew install stow

###########################################
#Dev Tools
###########################################

# http-server
npm install -g http-server

# zx https://github.com/google/zx
npm install -g zx

# JO https://github.com/jpmens/jo
brew install jo

# JQ https://stedolan.github.io/jq/
brew install jq

# JQ https://github.com/noahgorstein/jqp
brew install noahgorstein/tap/jqp

#YQ https://github.com/mikefarah/yq
brew install yq

# pup https://github.com/ericchiang/pup
brew install pup

# htmlq https://github.com/mgdm/htmlq
 brew install htmlq

# trdql https://github.com/noborus/trdsql
brew install noborus/tap/trdsql

# https://httpie.io
 brew install httpie

# https://github.com/so-fancy/diff-so-fancy
brew install diff-so-fancy

# entr
brew install entr

# Python
brew install pyenv
# brew install python
# sudo pip3 install appkit
# sudo pip3 install -U pyobjc


# Lazy Git
brew install lazygit

# NeoVim
brew install neovim

# Git Delta
brew install git-delta

# TLDR
brew install tealdeer

###########################################
#Docker
###########################################
brew install lazydocker

###########################################
# File Management
###########################################

# rclone
brew install rclone

# Midnight Commander
brew install mc

# tree
brew install tree

# DUF https://github.com/muesli/duf
brew install duf

# Tag
brew install tag

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils

# FD
brew install fd

# https://github.com/sharkdp/bat#installation
brew install bat

# https://dev.yorhel.nl/ncdu
 brew install ncdu

# https://github.com/ogham/exa
brew install exa

# FZF
brew isntall fzf

###########################################
#File Processing - JSON, CSV, XML, PDF
###########################################
# https://github.com/antonmedv/fx
npm install -g fx

# https://jless.io
brew install jless

# JSON PP
brew install jsonpp

# Ghostscript
brew install gs

# GNU Awk
brew install gawk

# MDLess
brew install mdless

###########################################
#Fun tools
###########################################
# SL (train)
brew install sl

# Fortune
brew install fortune

# Cowsay
brew install cowsay

# Toilet and Figlet
brew install toilet
brew install figlet

# Matrix
brew install cmatrix

# Boxes
brew install boxes

###########################################
#Media
###########################################

# ffmpeg
brew install ffmpeg

# yt-dlp
brew install yt-dlp

# imagemagick
brew install imagemagick

###########################################
#Networking
###########################################
# GPing
npm install gping

# Speedtest
brew tap teamookla/speedtest && brew update && brew install speedtest

# Wifi Password
brew install wifi-password

# Wake on Lan
brew install wakeonlan

###########################################
#Process Management
###########################################
# htop
brew install htop

# BTop
brew install btop

###########################################
#Productivity
###########################################
brew install mailsy

###########################################
# Searching
###########################################

# Ripgrep https://github.com/BurntSushi/ripgrep
brew install ripgrep

# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed

###########################################
#System Info
###########################################

# archey - system information
brew install archey

# Neofetch
brew install neofetch


###########################################
#Shell Customization
###########################################
brew install starship

# Gum
brew install gum

