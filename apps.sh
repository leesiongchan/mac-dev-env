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
  hyperterm
  kaleidoscope
  kitematic
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
echo "installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}
