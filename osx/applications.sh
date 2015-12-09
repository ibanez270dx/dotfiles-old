#!/bin/sh

# First install homebrew and cask
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install cask

# Applications
brew cask install 1password
brew cask install anvil
brew cask install atom
brew cask install bartender
brew cask install google-chrome
brew cask install iterm2
brew cask install parallels
brew cask install sidestep
brew cask install moom
brew cask install karabiner
brew cask install seil
brew cask install flux
brew cask install the-unarchiver
brew cask install bettertouchtool
brew cask install adobe-photoshop-cc
brew cask install adobe-illustrator-cc
brew cask install amazon-cloud-drive
brew cask install utorrent
brew cask install cheatsheet
brew cask install cleanmymac
brew cask install duplicate-annihilator
brew cask install evernote
brew cask install slack
brew cask install twitteriffic

# Development
brew install libmemcached memcached openssl git ack readline libxml2
brew install npm
brew install rbenv rbenv-build
brew cask install bowery
brew cask install colorpicker-developer
brew cask install electron
brew cask install imageoptim
brew cask install paparazzi
brew cask install rowanj-gitx

# MySQL + Config
brew install mysql
ln -sfv /usr/local/opt/mysql/*.plist ~/Library/LaunchAgents
launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist

# Collection of Quicklook extensions
brew cask install animated-gif-quicklook
brew cask install qlcolorcode
brew cask install qlstephen
brew cask install qlmarkdown
brew cask install quicklook-json
brew cask install qlprettypatch
brew cask install quicklook-csv
brew cask install betterzipql
brew cask install qlimagesize
brew cask install webpquicklook
brew cask install suspicious-package

# Emulators for old PC games :D
brew cask install dosbox
brew cask install scummvm
