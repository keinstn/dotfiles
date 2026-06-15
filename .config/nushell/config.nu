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

export def terminal-splits [action?: string] {
    let marker  = ($nu.home-path | path join ".config" "terminal-splits-on")
    let splits  = ($nu.home-path | path join ".config" "ghostty" "splits.ghostty")
    let ts_on   = ($nu.home-path | path join ".config" "ghostty" "splits-terminal.ghostty")
    let ts_off  = ($nu.home-path | path join ".config" "ghostty" "splits-tmux.ghostty")
    let wez_lua = ($nu.home-path | path join ".config" "wezterm" "wezterm.lua")
    let is_on   = ($marker | path exists)
    let cmd     = if ($action == null) { "toggle" } else { $action }

    match $cmd {
        "status" => { print (if $is_on { "terminal-splits: ON" } else { "terminal-splits: OFF (tmux mode)" }) }
        "on"     => { if $is_on { print "already ON" } else { ts-apply "on"  $marker $splits $ts_on $ts_off $wez_lua } }
        "off"    => { if not $is_on { print "already OFF" } else { ts-apply "off" $marker $splits $ts_on $ts_off $wez_lua } }
        "toggle" => { if $is_on { ts-apply "off" $marker $splits $ts_on $ts_off $wez_lua } else { ts-apply "on" $marker $splits $ts_on $ts_off $wez_lua } }
        _ => { error make { msg: "Usage: terminal-splits [on|off|toggle|status]" } }
    }
}

def ts-apply [mode: string, marker: string, splits: string, ts_on: string, ts_off: string, wez: string] {
    if $mode == "on" {
        touch $marker
        if $nu.os-info.name != "windows" { ^ln -sf $ts_on $splits }
        print "terminal-splits: ON"
    } else {
        if ($marker | path exists) { rm $marker }
        if $nu.os-info.name != "windows" { ^ln -sf $ts_off $splits }
        print "terminal-splits: OFF (tmux mode)"
    }
    if ($wez | path exists) { touch $wez }
    print "  wezterm: reloading automatically"
    print "  ghostty: Ctrl+Q R (or View > Reload Config) to apply"
}
