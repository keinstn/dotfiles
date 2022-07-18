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
  kind \
  kubernetes-cli \
  litecli \
  llvm \
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
  homebrew/cask-fonts \
  dbcli/tap \
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

# tap
for tap in ${taps}; do
  brew tap ${tap}
done


# Install formulas
brew install ${formulas}

# Install casks
brew install ${casks} --cask
