#!/bin/bash
formulas="\
  awscli \
  bat \
  bottom \
  colima \
  csvlens \
  dep \
  diff-so-fancy \
  direnv \
  docker \
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
  just \
  kind \
  kubernetes-cli \
  leaf-md \
  litecli \
  llvm \
  lua-language-server \
  mycli \
  neovim \
  nodejs \
  nushell \
  silicon \
  pass \
  pgcli \
  pngquant \
  rbenv \
  rg \
  starship \
  stow \
  stylua \
  tdf \
  tfenv \
  tflint \
  tfsec \
  tmux \
  tree \
  uv \
  wasmer \
  xcodebuildmcp \
  yarn \
  zig \
"

taps="\
  homebrew/cask-fonts \
  dbcli/tap \
  leoafarias/fvm \
  getsentry/xcodebuildmcp \
  manaflow-ai/cmux \
"

casks="\
  claude-code \
  cmux \
  font-hack-nerd-font \
  flutter \
  ghostty \
  google-cloud-sdk \
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
