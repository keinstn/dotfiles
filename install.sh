#!/bin/bash

xcode-select --install

# Install packages
source ./brew.sh

# Install configurations via stow
mkdir -p ~/.config
cd "$(dirname "${BASH_SOURCE[0]}")"
stow .

# Change default shell to fish
chsh -s $(which fish)

# Install Rust
curl https://sh.rustup.rs -sSf | sh

# Install packer.nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Install Volta
curl https://get.volta.sh | bash

# Install Aider with Python 3.12 because pydub still expects audioop, which was removed in 3.13
uv tool install --python 3.12 --reinstall aider-chat

# Install diff-so-fancy
curl https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy \
    -o /usr/local/bin/diff-so-fancy
chmod 755 /usr/local/bin/diff-so-fancy
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
