#!/bin/bash
formulas="\
  direnv \
  fish \
  fzf \
  jq \
  neovim \
  nodejs \
  pass \
  pyenv \
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

# Install formulas
brew install ${formulas}

# Install casks
brew cask install ${casks}
