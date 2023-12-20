#!/bin/bash
formulas="\
  awscli \
  bat \
  dep \
  diff-so-fancy \
  direnv \
  docker-machine-driver-hyperkit \
  dust \
  exa \
  fd \
  fish \
  fzf \
  git-secrets \
  go \
  hashicorp/tap/terraform-ls \
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
  rg \
  starship \
  tfenv \
  tflint \
  tfsec \
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
  flutter \
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
for formula in ${formulas}; do
  brew install ${formula}
done

# Install casks
brew install ${casks} --cask
