#!/bin/bash

# Install by url
# curl 'https://raw.github.com/evanmoran/.files/master/.ubuntu' | bash

# Run auto echos
function run { echo -e "[$@]"; $@; }

function apt_install {
  echo -n "Install $1 (with apt-get): "

  (run dpkg --get-selections | grep "^$1\s" > /dev/null) && (echo "Already Installed") || (run sudo apt-get --yes install $1)
}

function npm_install {
  echo -n "Install $1 (with npm): "
  (run npm list -g | grep $1 > /dev/null) && echo "Already Installed"
  (run npm list -g | grep $1 > /dev/null) || (run sudo npm install -g $1)
}

function link {
  echo -n "Install $1 (with npm): "
  (run npm list -g | grep $1 > /dev/null) && echo "Already Installed"
  (run npm list -g | grep $1 > /dev/null) || (run sudo npm install -g $1)
}

function apt_search_starts_with {
  (run apt-cache search "$1" | grep "^$1")
}

# Fix broken apt-get dependencies
echo "Fix broken apt-get dependencies"
sudo apt-get -f install

##############################################################
# Install apps
##############################################################

apt_install git
apt_install zsh
apt_install make
apt_install tree
apt_install emacs23-nox
apt_install p7zip

apt_install nodejs

echo "Add key to apt-get for mongodb"
run sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" | sudo tee /etc/apt/sources.list.d/10gen.list
echo "Update apt-get for mongodb"
sudo apt-get -y update
apt_install "mongodb-10gen"

echo "Install npm (with curl)"
(which npm > /dev/null) || (curl https://npmjs.org/install.sh | sudo sh)

##############################################################
# Install npm apps
##############################################################

npm_install "coffee-script"         # Javascript templating
npm_install "node-dev"              # Auto node restarting
npm_install "mocha"                 # Node test framework

##############################################################
# Install zshrc
##############################################################
echo 'Install zshrc (git clone)'
run git clone git://github.com/evanmoran/.files.git "${HOME}/.files"
run "${HOME}/.files/.links"

# Update submodules
(cd "${HOME}/.files"; git submodule update --init --recursive)

##############################################################
# Install zsh
##############################################################

echo 'Installing zsh'
run sudo chsh -s `which zsh` `whoami`

##############################################################
# Set location
##############################################################
echo 'Setting location to "server"'
echo 'server' > "${HOME}/.location"
