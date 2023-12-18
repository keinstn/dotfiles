#!/bin/bash

xcode-select --install

# Install packages
source ./brew.sh

# Install configurations
absolute_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ ! -e ~/.config ]]; then
  ln -s ${absolute_path}/.config ~/.config
fi

# Change default shell to fish
chsh -s $(which fish)

# Install Rust
curl https://sh.rustup.rs -sSf | sh

# Install packer.nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Install Volta
curl https://get.volta.sh | bash

# Install diff-so-fancy
curl https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy \
    -o /usr/local/bin/diff-so-fancy
chmod 755 /usr/local/bin/diff-so-fancy
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"

# Install rye
curl -sSf https://rye-up.com/get | bash
