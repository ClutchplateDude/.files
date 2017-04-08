#!/bin/bash

# curl 'https://raw.github.com/evanmoran/.files/master/.osx' | bash

# Run auto echos
function run { echo -e "[$@]"; $@; }

function brew_install {
  echo -n "Install $1 (with brew): "
  (run brew list | grep $1 > /dev/null) && echo "Already Installed"
  (run brew list | grep $1 > /dev/null) || (run brew install $1)
}

function brew_cask_install {
  echo -n "Install $1 (with brew cask): "
  (run brew list | grep $1 > /dev/null) && echo "Already Installed"
  (run brew list | grep $1 > /dev/null) || (run brew cask install $1)
}

function brew_tap {
  echo -n "Install $1 (with brew tap): "
  (run brew list | grep $1 > /dev/null) && echo "Already Installed"
  (run brew list | grep $1 > /dev/null) || (run brew tap $1)
}

function npm_install {
  echo -n "Install $1 (with npm): "
  (run npm list -g | grep $1 > /dev/null) && echo "Already Installed"
  (run npm list -g | grep $1 > /dev/null) || (run npm install -g $1)
}

##############################################################
# Install links
##############################################################
run "${HOME}/.files/.links"

# Update submodules
(cd "${HOME}/.files"; git sup)

##############################################################
# Install zsh
##############################################################

sudo chsh -s `which zsh` `whoami`

##############################################################
# Install commandline apps
##############################################################

echo "Install brew (with curl): "
echo "Important: '/usr/local/bin' must be before '/usr/bin' in path"
(which brew > /dev/null) || (/usr/bin/ruby -e "$(/usr/bin/curl -fksSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)")

brew_install git
brew_install git-extras
brew_install tig
brew_install zsh
brew_install nodejs
brew_install mongodb
brew_install coreutils  # gnu version of utility (used for dircolors)
brew_install python
brew_install python3
brew_install unrar
brew_install p7zip
brew_install xz
brew_install ack
brew_install cmake
brew_install openssl
brew_install tree
brew_install nmap
brew_install wget
brew_install llvm

##############################################################
# Install osx apps
##############################################################
brew_cask_install sublime3
brew_cask_install racket
brew_cask_install vim
# for mit-scheme
brew_tap homebrew/x11
brew_cask_install xquartz
brew_cask_install mit-scheme
# better scheme repl support
brew_install rlwrap

##############################################################
# Install oh-my-zsh
##############################################################
echo "Install oh-my-zsh (with curl): "
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

##############################################################
# Python, virtualenv, virtualenvwrapper
##############################################################
sudo easy_install pip
sudo pip install virtualenv
sudo pip install virtualenvwrapper
sudo pip install pytest               # testing framework module for python
sudo pip install pygments             # color output module

# Node.js framework
npm_install "coffee-script"         # Javascript templating
npm_install "node-dev"              # Auto node restarting
npm_install "mocha"                 # Node test framework
npm_install "pygments"              # Syntax highlighting used by docco
npm_install "docco"                 # Documentation generator
npm_install "groc"                  # Documentation generator

##############################################################
# Setup XCode Themes
##############################################################

mkdir -p ~/Library/Developer/Xcode/UserData/FontAndColorThemes
cp ~/.files/Solarized*.dvtcolortheme ~/Library/Developer/Xcode/UserData/FontAndColorThemes

echo 'Prevent XCode warning when undoing paste save point'
defaults write com.apple.Xcode XCShowUndoPastSaveWarning NO

##############################################################
# Setup OSX GUI
##############################################################

echo 'General: Expanded save as dialogs by default'
defaults write -g NSNavPanelExpandedStateForSaveMode -bool YES

echo 'General; Remove accounts from login options'
sudo defaults write /Library/Preferences/com.apple.loginwindow HiddenUsersList -array-add shortname1 shortname2 shortname3

echo 'General: Faster keyboard repeat rate'
defaults write NSGlobalDomain KeyRepeat -int 2

echo 'General: Faster keyboard initial delay'
defaults write NSGlobalDomain InitialKeyRepeat -int 20

echo 'General: Remove international press and hold shortcut'
defaults write -g ApplePressAndHoldEnabled -bool false

echo 'Finder: Show hidden files'
defaults write com.apple.Finder AppleShowAllFiles YES

echo 'Finder: Enable tabing through all controls (including buttons)'
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

echo 'Finder: Automatically open a new Finder window when a volume is mounted'
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true

echo 'Finder: Display full path in window title'
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

echo 'Finder: Avoid creating .DS_Store files on network volumes'
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

echo 'Finder: Show all file extensions'
defaults write -g AppleShowAllExtensions -bool YES;

echo 'Finder: Disable the warning when changing a file extension'
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# echo 'Desktop: Enable snap-to-grid for icons'
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

echo 'Desktop: Disable icons entirely'
defaults write com.apple.finder CreateDesktop -bool false

echo 'Safari: Development menu in Safari'
defaults write com.apple.safari IncludeDebugMenu -bool YES

echo 'Dock: Auto hide on'
defaults write com.apple.dock autohide -bool YES;

echo 'Dock: Put on right'
defaults write com.apple.dock orientation -string right;

echo 'Dock: Remove the auto-hiding delay'
defaults write com.apple.dock autohide-delay -float 0

echo 'Dock: Speed up the animation when hiding and showing'
defaults write com.apple.dock autohide-time-modifier -float 0.2

echo 'Dock: Set the icon size'
defaults write com.apple.dock tilesize -int 55

echo 'Finder: Show status bar'
defaults write com.apple.finder ShowStatusBar -bool true

echo 'Finder: Show path bar'
defaults write com.apple.finder ShowPathbar -bool true

echo 'Finder: Disable shadow in screenshots'
defaults write com.apple.screencapture disable-shadow -bool true

echo 'Finder: Save screenshots to png'
defaults write com.apple.screencapture type -string “png”

echo 'Terminal: Only use UTF-8 in Terminal.app'
defaults write com.apple.terminal StringEncodings -array 4

echo 'Terminal: Create Terminal shortcuts for switching tabs Chrome style (opt+cmd+right/left)'
defaults write com.apple.Terminal NSUserKeyEquivalents -dict-add "Select Next Tab" "~@→"
defaults write com.apple.Terminal NSUserKeyEquivalents -dict-add "Select Previous Tab" "~@←"

echo 'Hot Corners: Bottom right screen corner → Show Current Windows'
defaults write com.apple.dock wvous-br-corner -int 3
defaults write com.apple.dock wvous-br-modifier -int 0

echo 'Hot Corners: Bottom left screen corner → Show All Windows'
defaults write com.apple.dock wvous-bl-corner -int 2
defaults write com.apple.dock wvous-bl-modifier -int 0

echo 'Hot Corners: Top right screen corner → Start screen saver'
defaults write com.apple.dock wvous-tr-corner -int 5
defaults write com.apple.dock wvous-tr-modifier -int 0

echo 'Time Machine: Prevent Time Machine from prompting to use new hard drives as backup volume'
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

echo 'Mission Control: Speed up animations'
defaults write com.apple.dock expose-animation-duration -float 0.1

echo 'Spaces: Don’t automatically rearrange Spaces based on most recent use'
defaults write com.apple.dock mru-spaces -bool false

echo 'Kill affected applications'
for app in Xcode Safari Finder Dock Mail Dashboard; do killall "$app"; done



