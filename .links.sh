#!/bin/sh

function is_os {
  if [ $1 = "windows" ] && [ "$OS" = "Windows_NT" ]; then
    return 0
  elif [ $1 = "osx" ] && [ ! "$OS" = "Windows_NT" ]; then
    return 0
  fi
  return 1
}

# Run -- Echo your command as it is run
function run { echo "[$@]"; $@; }

if is_os "osx"; then
  run ln -s $HOME/.files/.gitconfig $HOME/.gitconfig
  run ln -s $HOME/.files/.bash_profile $HOME/.bash_profile
  run ln -s $HOME/.files/.ackrc $HOME/.ackrc
fi
