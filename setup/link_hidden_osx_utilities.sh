#!/usr/bin/env sh

# Links to hidden utilities
echo "Creating links to hidden utilities.."

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

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

echo "Done linking."
