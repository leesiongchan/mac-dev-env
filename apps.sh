#!/bin/bash
# Apps
apps=(
  atom
  docker
  dropbox
  firefox
  google-chrome
  google-drive
  kaleidoscope
  postico
  qlimagesize
  skype
  slack
  spotify
  sublime-text
  tower
  transmission
  transmit
  vlc
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}
