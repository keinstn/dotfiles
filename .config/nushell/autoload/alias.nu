# Aliases
alias vim = nvim
alias cat = bat
alias l = eza
alias ll = eza -lh --git

if $nu.os-info.name == "windows" {
    alias vimdiff = nvim -d
    alias popen = pwsh Invoke-Item
}
