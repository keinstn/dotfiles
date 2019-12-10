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

# Install fisherman
fish ./fisherman.fish

# Install Rust
curl https://sh.rustup.rs -sSf | sh

# Install vim-plug
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install notedown
pip install --prefix=/usr/local notedown

# Install LSP
pip3 install --prefix=/usr/local python-language-server
yarn global add javascript-typescript-langserver
yarn global add vue-language-server

# Install Volta
curl https://get.volta.sh | bash

# Install npm packages
volta install tldr
