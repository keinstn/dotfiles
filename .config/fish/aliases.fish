if type -q batcat
    alias cat="batcat"
else
    alias cat="bat"
end

if type -q fdfind
    alias find="fdfind"
else
    alias find="fd"
end
alias ls="eza"
alias ll="eza -lh --git"
alias tmux="tmux -f ~/.config/tmux/tmux.conf"
alias vim="nvim"
alias kc="kubectl"
alias f="fvm flutter"
alias d="fvm dart"
