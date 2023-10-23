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
  git-secrets \
  go \
  hashicorp/tap/terraform-ls \
  hashicorp/tap/hashicorp-vagrant \
  htop \
  jq \
  kind \
  kubernetes-cli \
  litecli \
  llvm \
  mycli \
  neovim \
  nodejs \
  silicon \
  pass \
  pgcli \
  pyenv \
  python3 \
  rbenv \
  rg \
  starship \
  tfenv \
  tflint \
  tfsec \
  tldr \
  tmux \
  tree \
  wasmer \
  yarn \
  zig \
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
  wezterm \
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
