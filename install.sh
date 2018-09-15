#!/bin/bash

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
