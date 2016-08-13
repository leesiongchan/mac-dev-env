#!/bin/bash
# Apps
apps=(
  appcleaner
  atom
  cloudup
  dropbox
  droplr
  firefox
  githubpulse
  google-chrome
  google-drive
  harvest
  namechanger
  postico
  qlimagesize
  skype
  slack
  spotify
  sublime-text
  tomighty
  tower
  transmission
  transmit
  vlc
)

# Install apps to /Applications
# Default is: /Users/$user/Applications
echo "installing apps..."
brew cask install --appdir="/Applications" ${apps[@]}
