#!/bin/bash
set packages "
  fzf
  git_util 
  lfiolhais/theme-simple-ass-prompt
"
# Install fisherman
curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher

# Install packages
fisher $packages
