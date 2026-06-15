set -g __ts_marker "$HOME/.config/terminal-splits-on"
set -g __ts_splits "$HOME/.config/ghostty/splits.ghostty"
set -g __ts_on     "$HOME/.config/ghostty/splits-terminal.ghostty"
set -g __ts_off    "$HOME/.config/ghostty/splits-tmux.ghostty"
set -g __ts_wez    "$HOME/.config/wezterm/wezterm.lua"

function terminal-splits
    set -l subcmd (test -n "$argv[1]"; and echo $argv[1]; or echo toggle)
    set -l is_on (test -f $__ts_marker; and echo true; or echo false)

    switch $subcmd
        case status
            if test "$is_on" = true
                echo "terminal-splits: ON"
            else
                echo "terminal-splits: OFF (tmux mode)"
            end
        case on
            test "$is_on" = true; and echo "already ON"; and return
            __ts_apply on
        case off
            test "$is_on" = false; and echo "already OFF"; and return
            __ts_apply off
        case toggle
            if test "$is_on" = true
                __ts_apply off
            else
                __ts_apply on
            end
        case '*'
            echo "Usage: terminal-splits [on|off|toggle|status]"
            return 1
    end
end

function __ts_apply
    if test "$argv[1]" = on
        touch $__ts_marker
        if command -q ghostty
            ln -sf $__ts_on $__ts_splits
        end
        echo "terminal-splits: ON"
    else
        rm -f $__ts_marker
        if command -q ghostty
            ln -sf $__ts_off $__ts_splits
        end
        echo "terminal-splits: OFF (tmux mode)"
    end
    test -f $__ts_wez; and touch $__ts_wez
    echo "  wezterm: reloading automatically"
    echo "  ghostty: Ctrl+Q R (or View > Reload Config) to apply"
end
