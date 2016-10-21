#!/bin/sh

# Some things taken from here
# https://github.com/mathiasbynens/dotfiles/blob/master/.osx

pretty_print() {
  printf "\n%b\n" "$1"
}

checkFor() {
  type "$1" &> /dev/null ;
}

pretty_print "Setting up your dev environment like a boss..."

# Set continue to false by default
CONTINUE=false

pretty_print "\n###############################################"
pretty_print "#        DO NOT RUN THIS SCRIPT BLINDLY       #"
pretty_print "#         YOU'LL PROBABLY REGRET IT...        #"
pretty_print "#                                             #"
pretty_print "#              READ IT THOROUGHLY             #"
pretty_print "#         AND EDIT TO SUIT YOUR NEEDS         #"
pretty_print "###############################################\n\n"

pretty_print "Have you read through the script you're about to run and "
pretty_print "understood that it will make changes to your computer? (y/n)"
read -r response
case $response in
  [yY]) CONTINUE=true
      break;;
  *) break;;
esac

if ! $CONTINUE; then
  # Check if we're continuing and output a message if not
  pretty_print "Please go read the script, it only takes a few minutes"
  exit
fi

# Here we go.. ask for the administrator password upfront and run a
# keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Finder
###############################################################################

echo "\nAdding a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Use current directory as default search scope in Finder
echo "\nUse current directory as default search scope in Finder"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Set a blazingly fast keyboard repeat rate
echo "\nSet a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 1

# Set a shorter Delay until key repeat
echo "\nSet a shorter Delay until key repeat"
defaults write NSGlobalDomain InitialKeyRepeat -int 12

###############################################################################
# Development Tools
###############################################################################

# xcode dev tools
pretty_print "Installing xcode dev tools..."
  if [ "$(checkFor pkgutil --pkg-info=com.apple.pkg.CLTools_Executables)" ]; then
    printf 'Command-Line Tools is not installed.  Installing..' ;
    xcode-select --install
    sleep 1
    osascript -e 'tell application "System Events"' -e 'tell process "Install Command Line Developer Tools"' -e 'keystroke return' -e 'click button "Agree" of window "License Agreement"' -e 'end tell' -e 'end tell'
  fi

# Oh my zsh installation
pretty_print "Installing oh-my-zsh..."
  curl -L http://install.ohmyz.sh | sh

# Homebrew installation
if ! command -v brew &>/dev/null; then
  pretty_print "Installing Homebrew, an OSX package manager, follow the instructions..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

  if ! grep -qs "recommended by brew doctor" ~/.zshrc; then
    pretty_print "Put Homebrew location earlier in PATH ..."
      printf '\n# recommended by brew doctor\n' >> ~/.zshrc
      printf 'export PATH="/usr/local/bin:$PATH"\n' >> ~/.zshrc
      export PATH="/usr/local/bin:$PATH"
  fi
else
  pretty_print "You already have Homebrew installed...good job!"
fi

# Homebrew OSX libraries
pretty_print "Updating brew formulas"
  brew update

pretty_print "Installing GNU core utilities..."
	brew install coreutils

pretty_print "Installing GNU find, locate, updatedb and xargs..."
	brew install findutils

pretty_print "Installing the most recent version of some OSX tools"
	brew tap homebrew/dupes
	brew install homebrew/dupes/grep

printf 'export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"' >> ~/.zshrc
export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"

# Git installation
pretty_print "Installing git for control version"
  brew install git

# Git setup
pretty_print "Setting up .gitconfig... (y/n)"
# Write settings to ~/.gitconfig
read -r response
case $response in
  [yY])
    echo "What name would you like use?"
    read NAME
    # $NAME for usage
    git config --global user.name $NAME

    echo "What email would you like use?"
    read EMAIL
    # $EMAIL for usage
    git config --global user.email $EMAIL

    # a global git ignore file:
    git config --global core.excludesfile '~/.gitignore'
    echo '.DS_Store' >> ~/.gitignore

    # use keychain for storing passwords
    git config --global credential.helper osxkeychain

    # you might not see colors without this
    git config --global color.ui true

    echo "more useful settings can be found here: https://github.com/glebm/dotfiles/blob/master/.gitconfig"

    break;;
  *) break;;
esac

# OpenSSL linking
pretty_print "Installing and linking OpenSSL..."
  brew install openssl
  brew link openssl --force

pretty_print "Installing htop..."
  brew install htop

pretty_print "Installing Watchman..."
  brew install watchman

pretty_print "Installing Node Version Manager..."
  brew install n

pretty_print "Installing Node Package Manager..."
  brew install yarn

# Install brew cask
pretty_print "Installing cask to install apps"
	brew tap caskroom/cask
  brew tap caskroom/versions

pretty_print "Installing apps..."
  sh apps.sh

pretty_print "Installing fonts..."
  sh fonts.sh

pretty_print "Installing Gulp, Hyperterm CLI, and Pure theme..."
  yarn global add gulp hpm-cli pure-prompt npm-check-updates

# Install Mackup
pretty_print "Installing Mackup..."
  brew install mackup

# when done with cask
brew update && brew upgrade brew-cask && brew cleanup && brew cask cleanup

# Launch it and back up / restore your files
echo ""
echo "Do you want to (backup / restore) your files from Mackup? (b/r)"
read -r response
case $response in
  [bB])
    mackup backup
    break;;
  [rR])
    ln -s ~/Library/Mobile\ Documents/com\~apple\~CloudDocs/Mackup/.mackup.cfg ~/.mackup.cfg
    mackup restore
    break;;
  *) break;;
esac

###############################################################################
# Transmission.app                                                            #
###############################################################################

echo ""
echo "Do you use Transmission for torrenting? (y/n)"
read -r response
case $response in
  [yY])
    echo ""
    echo "Use `~/Downloads/Incomplete` to store incomplete downloads"
    defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
    mkdir -p ~/Downloads/Incomplete
    defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads/Incomplete"

    echo ""
    echo "Auto watch for torrent files in `~/Downloads`"
    defaults write org.m0k.transmission AutoImportDirectory ~/Downloads

    echo ""
    echo "Don't prompt for confirmation before downloading"
    defaults write org.m0k.transmission DownloadAsk -bool false

    echo ""
    echo "Trash original torrent files"
    defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

    echo ""
    echo "Hide the donate message"
    defaults write org.m0k.transmission WarningDonate -bool false

    echo ""
    echo "Hide the legal disclaimer"
    defaults write org.m0k.transmission WarningLegal -bool false
    break;;
  *) break;;
esac

###############################################################################
# Kill affected applications
###############################################################################

echo ""
pretty_print "Shits Done Bro! You still need to manually install package installer within sublime, setup your hosts, httpd.conf and vhosts files, download chrome extensions, setup your hotspots/mouse settings, and setup your git shit - look at readme for more info."
echo ""
echo ""
pretty_print "################################################################################"
echo ""
echo ""
pretty_print "Note that some of these changes require a logout/restart to take effect."
pretty_print "Killing some open applications in order to take effect."
echo ""

find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete
for app in "Activity Monitor" "Address Book" "Calendar" "Contacts" "cfprefsd" \
  "Dock" "Finder" "Mail" "Messages" "Safari" "SystemUIServer" \
  "Terminal" "Transmission"; do
  killall "${app}" > /dev/null 2>&1
done
