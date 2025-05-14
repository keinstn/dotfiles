# config.nu
#
# Installed by:
# version = "0.104.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

# Aliases
alias vim = nvim
alias cat = bat
alias x = eza --icons
alias xa = eza --icons --all
alias xl = eza --icons -lh --git
alias xla = eza --icons --long --all
alias xt = eza --icons --tree
alias xta = eza --icons --tree --all
alias vimdiff = nvim -d
alias nu-open = open

# Functions
export def ln-s [src:path, dest:path] {
    if $nu.os-info.name == "windows" {
        pwsh -c $"New-Item -ItemType SymbolicLink -Path ($dest) -Value ($src)"
    } else {
        ^ln -s $src $dest
    }
}

export def open [it:path] {
    if $nu.os-info.name == "windows" {
        pwsh -c $"Invoke-Item ($it)"
    } else {
        ^open $"($it)"
    }
}

export def shutdown [] {
    if $nu.os-info.name == "windows" {
        pwsh -c "Stop-Computer"
    } else {
        sudo shutdown -h now
    }
}

export def reboot [] {
    if $nu.os-info.name == "windows" {
        pwsh -c "Restart-Computer"
    } else {
        sudo reboot
    }
}
