#!/bin/bash
formulas="\
  awscli \
  bat \
  bottom \
  dep \
  diff-so-fancy \
  direnv \
  docker-machine-driver-hyperkit \
  dust \
  eza \
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
  lua-language-server \
  mycli \
  neovim \
  nodejs \
  silicon \
  pass \
  pgcli \
  rbenv \
  rg \
  starship \
  stylua \
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
  neovide \
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
