#!/bin/sh

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Disable icons on the desktop
defaults write com.apple.finder CreateDesktop -bool false

# Set screenshot save location
mkdir ~/Desktop/Screenshots
defaults write com.apple.screencapture location -string "~/Desktop/Screenshots"
defaults write com.apple.screencapture include-date -bool true

# Enable Safari's Debug, Developer, and Web Inspector Menus
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Enable Dark theme for UI, Menu bar, and Spotlight
defaults write NSGlobalDomain AppleInterfaceTheme -string 'Dark'
defaults write NSGlobalDomain NSFullScreenDarkMenu -bool true
defaults write com.apple.Spotlight AppleInterfaceStyle -string 'Dark'

# Check for software updates daily, not just once per week
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Enable AirDrop over Ethernet and on unsupported Macs
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Mount network disks before logging in
defaults write /Library/Preferences/SystemConfiguration/autodiskmount AutomountDisksWithoutUserLogin -bool true

# Copy text from quicklook
defaults write com.apple.finder QLEnableTextSelection -bool true

# Only one user logged in at once
sudo defaults write NSGlobalDomain MultipleSessionEnabled -bool false

# Disable automatic login
sudo defaults write /Library/Preferences/com.apple.loginwindow com.apple.login.mcx.DisableAutoLoginClient -bool true

# Kiosk mode for login Screen
sudo defaults write /Library/Preferences/com.apple.loginwindow Kiosk -bool true

# Don't re-open apps on startup
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false

# Don't re-open apps when logging in
defaults write com.apple.loginwindow TALLogoutSavesState -bool false

################################################################################
# Dock
################################################################################

# Remove all dock icons
defaults write com.apple.dock persistent-apps -array

# Autohide
defaults write com.apple.dock autohide -bool true

# Hide unopen apps
defaults write com.apple.dock static-only -bool true

# No bounce
defaults write com.apple.dock no-bouncing -bool true

# Essentially "disable" the dock
defaults write com.apple.dock autohide-delay -float 1000

################################################################################
# Keys & Keyboard
################################################################################

# Disable smart quotes and smart dashes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable smart quotes in Message (Copy/Paste code!)
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# Set a shorter Delay until key repeat
defaults write NSGlobalDomain InitialKeyRepeat -int 12

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

################################################################################
# Finder
################################################################################

# Set default Finder location to home folder (~/)
defaults write com.apple.finder NewWindowTarget -string "PfLo" && \
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}"

# Show Path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Use current directory as default search scope in Finder
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show Path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show Status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Show the ~/Library folder
chflags nohidden ~/Library

# Show absolute path in finder's title bar.
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Make list view the default
defaults write com.apple.finder FXPreferredViewStyle -string 'Nlsv'
defaults write com.apple.finder FXPreferredSearchViewStyle -string 'Nlsv'

# Custom icona for remote volumes
defaults write com.apple.finder ShowCustomIconsForRemoteVolumes -bool true

# Custom icons for removable volumes
defaults write com.apple.finder ShowCustomIconsForRemovableVolumes -bool true

################################################################################
# Unhide Utilities
################################################################################

# Archive Utility
sudo ln -s "/System/Library/CoreServices/Applications/Archive Utility.app" "/Applications/Utilities/Archive Utility.app"

# Directory Utility
sudo ln -s "/System/Library/CoreServices/Applications/Directory Utility.app" "/Applications/Utilities/Directory Utility.app"

# Screen Sharing
sudo ln -s "/System/Library/CoreServices/Applications/Screen Sharing.app" "/Applications/Utilities/Screen Sharing.app"

# Ticket Viewer
sudo ln -s "/System/Library/CoreServices/Ticket Viewer.app" "/Applications/Utilities/Ticket Viewer.app"

# Network Diagnostics
sudo ln -s "/System/Library/CoreServices/Network Diagnostics.app" "/Applications/Utilities/Network Diagnostics.app"

# Network Utility
sudo ln -s "/System/Library/CoreServices/Applications/Network Utility.app" "/Applications/Utilities/Network Utility.app"

# Wireless Diagnostics
sudo ln -s "/System/Library/CoreServices/Applications/Wireless Diagnostics.app" "/Applications/Utilities/Wireless Diagnostics.app"

# Feedback Assistant
sudo ln -s "/System/Library/CoreServices/Applications/Feedback Assistant.app" "/Applications/Utilities/Feedback Assistant.app"

# RAID Utility
sudo ln -s "/System/Library/CoreServices/Applications/RAID Utility.app" "/Applications/Utilities/RAID Utility.app"

# System Image Utilitys
sudo ln -s "/System/Library/CoreServices/Applications/System Image Utility.app" "/Applications/Utilities/System Image Utility.app"

# iOS Simulator
sudo ln -s "/Applications/Xcode.app/Contents/Applications/iOS Simulator.app" "/Applications/iOS Simulator.app"

# Restart stuff so changes take effect
find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete
for app in "Activity Monitor" "cfprefsd" "Dock" "Finder" "Messages" "Safari" "SystemUIServer"; do
  killall "${app}" > /dev/null 2>&1
done

echo "Done!"
