#!/bin/bash
#Installing fonts
pretty_print "Installing some caskroom/fonts..."
brew tap caskroom/fonts

fonts=(
  font-lato
  font-montserrat
  font-open-sans
  font-poppins
  font-roboto
  font-roboto-mono
  font-ubuntu
)

# install fonts
pretty_print "Installing fonts..."
brew cask install ${fonts[@]}