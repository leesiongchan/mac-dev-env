#!/bin/bash
# Apps
apps=(
  atom
  dash
  docker
  docker-clean
  dropbox
  firefox
  google-chrome
  google-drive
  hyper
  kaleidoscope
  kitematic
  leech
  messenger
  postico
  qlimagesize
  skype
  slack
  spotify
  sshfs
  sublime-text
  the-unarchiver
  tower
  transmission
  transmit
  vlc
  whatsie
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "Installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}
