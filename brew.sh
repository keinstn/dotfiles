#!/bin/bash
formulas="\
  awscli \
  bat \
  dep \
  direnv \
  docker-machine-driver-hyperkit \
  exa \
  fd \
  fish \
  fzf \
  go \
  htop \
  jq \
  kubernetes-cli \
  mycli \
  neovim \
  nodejs \
  pass \
  pgcli \
  pyenv \
  python3 \
  rg \
  tmux \
  tree \
  yarn \
"

casks="\
  alacritty \
  google-cloud-sdk \
  docker \
  minikube \
"

# Install homebrew
if [[ $(which brew) == '' ]]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install formulas
brew install ${formulas}

# Install casks
brew cask install ${casks}
