#!/bin/bash
formulas="\
  awscli \
  direnv \
  docker-machine-driver-hyperkit \
  fish \
  fzf \
  htop \
  jq \
  kubernetes-cli \
  mycli \
  neovim \
  nodejs \
  pass \
  pgcli \
  pipenv \
  pyenv \
  python3 \
  rg \
  tmux \
  tree \
  yarn \
"

casks="\
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
