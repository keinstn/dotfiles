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
  kind \
  jq \
  kubernetes-cli \
  mycli \
  neovim \
  nodejs \
  pass \
  pgcli \
  pyenv \
  python3 \
  rbenv \
  rg \
  starship \
  tmux \
  tree \
  yarn \
"

taps="\
  homebrew/cask-fonts
"

casks="\
  alacritty \
  font-hack-nerd-font \
  google-cloud-sdk \
  docker \
"

# Install homebrew
if [[ $(which brew) == '' ]]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install formulas
brew install ${formulas}

# tap
for tap in ${taps}; do
  brew tap ${tap}
done

# Install casks
brew install ${casks} --cask
