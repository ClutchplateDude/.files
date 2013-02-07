#!/bin/bash

# Supported arguments: "windows", "osx", "linux"
function is_os {
  if [ -z "$OS" ]; then
    OS=$(uname -s)
    [ "$?" -eq 0 ] || return 0
  fi
  if [ $1 = "windows" ] && [ "$OS" = "Windows_NT" ]; then
    return 0
  elif [ $1 = "linux" ] && [ "$OS" = "Linux" ]; then
      return 0
  elif [ $1 = "osx" ] && [ "$OS" = "Darwin" ]; then
    return 0
  fi
  return 1
}

# Run -- Echo your command as it is run
function run { echo "[$@]"; $@; }

if is_os "osx" || is_os "linux"; then

  local SERVICES=Library/Services

  # Dot files
  run ln -s $HOME/.files/.gitconfig $HOME/.gitconfig
  run ln -s $HOME/.files/.bash_profile $HOME/.bash_profile
  run ln -s $HOME/.files/.zshrc $HOME/.zshrc
  run ln -s $HOME/.files/.ackrc $HOME/.ackrc
  run ln -s $HOME/.files/.dircolors $HOME/.dircolors
  run ln -s $HOME/d/.plan $HOME/.plan
  run ln -s $HOME/d/.notes $HOME/.notes

  # Services
  run cp -r $HOME/.files/osx/services/*.workflow $HOME/Library/Services/*.workflow

  # Backup UserData directory if present
  if [ ! -d $HOME/Library/Developer/Xcode/UserData.bak ] ; then
    echo "[Backing up $HOME/Library/Developer/Xcode/UserData]"
    mv $HOME/Library/Developer/Xcode/UserData $HOME/Library/Developer/Xcode/UserData.bak
  fi
  run ln -s $HOME/.files/.xcode/UserData $HOME/Library/Developer/Xcode/UserData
fi
