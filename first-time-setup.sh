#!/usr/bin/env bash

echo """!!! WARNING WARNING WARNING !!!
This script will HEAVILY reconfigure this system, including:
  - installing apps
  - overwriting config files
  - changing system settings
  - adding login items
  - etc.

Please read the script, understand it, and then run it at your own risk.
"""

read -p "I understand what this script does (type yes): " confirmation
if [ "$confirmation" != "yes" ]; then
  echo "Aborting."
  exit
fi

read -p "What type of computer is this? (personal/work/customer) " installation_type

if [ "$installation_type" != "personal" ] && [ "$installation_type" != "work" ] && [ "$installation_type" != "customer" ]; then
  echo "Invalid installation type."
  exit 1
fi

# Copy dotfiles into place -- do this first to get the git email prompt out of the way
./file-install.sh

# Ask for sudo password up front so the rest of the script can run unattended
sudo -v

# Ensure brew is installed
which -s brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"

# ggrep is required, otherwise some local helpers code will fail. Note that replacing ggrep with grep in that script
# will result in a segmentation fault.
brew install grep

# Install common apps
./program-install.sh shell gui-common

if [ "$installation_type" == "work" ]; then
  ./program-install.sh gui-work
fi

if [ "$installation_type" == "personal" ]; then
  ./program-install.sh gui-personal
fi

apps=(Raycast.app Amethyst.app Itsycal.app "Scroll Reverser.app")
for app in "${apps[@]}"; do
  open "/Applications/$app"
  osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"/Applications/$app\", hidden:false}"
done

# Disable default keybindings for Spotlight so that we can use raycast -- requires reboot
/usr/libexec/PlistBuddy ~/Library/Preferences/com.apple.symbolichotkeys.plist -c \
  "Set AppleSymbolicHotKeys:64:enabled false"

# This seems to work if Chrome is closed, but not if it's open
open -a "Google Chrome" --new --args --make-default-browser

if [ "$installation_type" == "work" ]; then
  posture_check='0 11,13,15 * * 1-5 osascript -e '"'"'display notification "Have you switched sit/stand positions recently?" with title "Posture" sound name "Purr"'"'"''
  { sudo crontab -l -u "$(whoami)"; echo "$posture_check"; } | sudo crontab -u "$(whoami)" -
fi

mkdir ~/Projects

# TODO:
# amethyst -- why isn't row layout shortcut key working?
# import raycast settings (should consider whether the settings file is sensitive)

# enable settings sync in vscode automatically?

# is it possible to change a whole host of system settings (dark mode, screen timeout, auto hide dock, single tap to click, etc.)?

# more plists:
# - obsidian


# should we reboot at the end?




## mac settings that were changed

appearance > dark
control center > select some hide/shows in the menu bar
desktop & dock > set automatically hide and show the dock
desktop & dock > Set click wallpaper to reveal desktop to "Only in stage manager"
desktop & dock > hot corners > disable quick note in bottom right
lock screen > set turn display off on batter when inactive to 'for 10 minutes'
lock screen > set turn display off on power adapter when inactive to 'for 1 hour'
mouse > set tracking speed to 7th click
trackpad > turn on tap to click


## finder

settings > advanced > when performing a search > set to "search the current folder"