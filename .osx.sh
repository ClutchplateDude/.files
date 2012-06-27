#!/bin/sh

# Run auto echos
function run { echo -e "[$@]"; $@; }

function brew_install {
  echo -n "Install $1 (with brew): "
  (run brew list | grep $1 > /dev/null) && echo "Already Installed"
  (run brew list | grep $1 > /dev/null) || (run brew install $1)
}

function npm_install {
  echo -n "Install $1 (with npm): "
  (run npm list -g | grep $1 > /dev/null) && echo "Already Installed"
  (run npm list -g | grep $1 > /dev/null) || (run npm install -g $1)
}

##############################################################
# Install apps
##############################################################

echo "Install brew (with curl): "
echo "Important: '/usr/local/bin' must be before '/usr/bin' in path"
(which brew > /dev/null) || (/usr/bin/ruby -e "$(/usr/bin/curl -fksSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)")

brew_install git
brew_install git-extras
brew_install zsh
brew_install nodejs
brew_install mongodb
brew_install python
brew_install ack
brew_install xz
brew_install p7zip
brew_install unrar
brew_install tree
brew_install nmap

echo "Install npm (with curl)"
(which npm > /dev/null) || (curl http://npmjs.org/install.sh | sh)

# Node.js framework
npm_install "coffee-script"         # Javascript templating
npm_install "nodemon"               # Auto node restarting
npm_install "watchit"               # Auto file watching

echo "Install plugin to support multiple heroku accounts"
echo "Note: Add accounts to heroku with: heroku accounts:add <name>"
heroku plugins:install git://github.com/ddollar/heroku-accounts.git

##############################################################
# Setup OSX GUI
##############################################################

echo 'Show hidden files in finder'
defaults write com.apple.Finder AppleShowAllFiles YES

echo 'Enable tabing through all controls (including buttons)'
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo 'Automatically open a new Finder window when a volume is mounted'
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true

echo 'Display full path in Finder window title'
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo 'Avoid creating .DS_Store files on network volumes'
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo 'Show all file extensions'
defaults write -g AppleShowAllExtensions -bool YES;

echo 'Disable the warning when changing a file extension'
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo 'Enable snap-to-grid for desktop icons'
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

echo 'Expanded save as dialogs by default'
defaults write -g NSNavPanelExpandedStateForSaveMode -bool YES

echo 'Remove accounts from login options'
sudo defaults write /Library/Preferences/com.apple.loginwindow HiddenUsersList -array-add shortname1 shortname2 shortname3

echo 'Development menu in Safari'
defaults write com.apple.safari IncludeDebugMenu -bool YES

echo 'Dock: Auto hide on'
defaults write com.apple.dock autohide -bool YES;

echo 'Dock: Put on right'
defaults write com.apple.dock orientation -string right;

echo 'Dock: Set the icon size to 48 pixels'
defaults write com.apple.dock tilesize -int 48

echo 'Show status bar in Finder'
defaults write com.apple.finder ShowStatusBar -bool true

echo 'Disable shadow in screenshots'
defaults write com.apple.screencapture disable-shadow -bool true

echo 'Only use UTF-8 in Terminal.app'
defaults write com.apple.terminal StringEncodings -array 4

echo 'Create Terminal shortcuts for switching tabs Chrome style (opt+cmd+right/left)'
defaults write com.apple.Terminal NSUserKeyEquivalents -dict-add "Select Next Tab" "~@→"
defaults write com.apple.Terminal NSUserKeyEquivalents -dict-add "Select Previous Tab" "~@←"

echo 'Hot Corners: Bottom right screen corner → Desktop'
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0

echo 'Hot Corners: Bottom left screen corner → Mission Control'
defaults write com.apple.dock wvous-bl-corner -int 2
defaults write com.apple.dock wvous-bl-modifier -int 0

echo 'Hot Corners: Top right screen corner → Start screen saver'
defaults write com.apple.dock wvous-tr-corner -int 5
defaults write com.apple.dock wvous-tr-modifier -int 0

echo 'Prevent Time Machine from prompting to use new hard drives as backup volume'
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo 'Kill affected applications'
for app in Safari Finder Dock Mail; do killall "$app"; done

