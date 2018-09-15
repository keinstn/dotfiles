#!/bin/bash
packages="\
  fish \
  fzf \
  neovim \
  pass \
  python3 \
  rg \
  tmux \
  tree \
"
casks="\
  docker \
"

# Install homebrew
if [[ $(which brew) == '' ]]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install packages
brew install ${packages}

# Install casks
brew cask install ${casks}

# Install Rust
curl https://sh.rustup.rs -sSf | sh

