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

# Install paq-nvim
git clone https://github.com/savq/paq-nvim.git \
    "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/opt/paq-nvim

# Install notedown
pip install --prefix=/usr/local notedown

# Install LSP
pip3 install --prefix=/usr/local python-language-server
yarn global add typescript-language-server
yarn global add typescript

# Install Volta
curl https://get.volta.sh | bash

# Install npm packages
volta install tldr

# Install diff-so-fancy
curl https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy \
    -o /usr/local/bin/diff-so-fancy
chmod 755 /usr/local/bin/diff-so-fancy
git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
