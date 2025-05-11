#!/bin/bash
formulas="\
  awscli \
  bat \
  bottom \
  dep \
  diff-so-fancy \
  direnv \
  docker-machine-driver-hyperkit \
  duckdb \
  dust \
  eza \
  fd \
  fish \
  fvm \
  fzf \
  gh \
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
  uv \
  wasmer \
  yarn \
  zig \
"

taps="\
  homebrew/cask-fonts \
  dbcli/tap \
  leoafarias/fvm \
"

casks="\
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
