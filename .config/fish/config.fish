# Load global secrets from ~/.env into environment variables
if test -f ~/.env
    for line in (cat ~/.env)
        # Skip empty lines and comments
        if string match -qr '^\s*($|#)' -- $line
            continue
        end
        # Strip optional `export ` prefix
        set line (string replace -r '^export\s+' '' -- $line)
        # Split into KEY and VALUE on the first `=`
        set parts (string split -m 1 '=' -- $line)
        if test (count $parts) -eq 2
            # Strip surrounding quotes from value
            set val (string trim -c '"' -- $parts[2])
            set val (string trim -c "'" -- $val)
            set -gx $parts[1] $val
        end
    end
end

source ~/.config/fish/aliases.fish
source ~/.config/fish/terminal-splits.fish

fish_vi_key_bindings

set -g simple_ass_prompt_greeting

set -g FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'

set -x PATH "/opt/homebrew/bin" $PATH
eval (brew shellenv)

if type -q gh
    set -gx GITHUB_MCP_PAT (gh auth token 2>/dev/null)
end

if not type -q brew
    set -x PATH "$HOME/.local/bin" $PATH
    set -x PATH "$HOME/.yarn/bin" $PATH
end

set -x PATH "$HOME/.local/bin" $PATH

set -x PATH "/usr/local/bin" $PATH

set -x PATH "$HOME/.cargo/bin" $PATH

set -x PATH "$HOME/go/bin" $PATH

set -x PATH "/usr/local/opt/llvm/bin" $PATH

eval (direnv hook fish)

starship init fish | source

# flutter
set -x PATH "$HOME/.pub-cache/bin" $PATH

set -x WEZTERM_CONFIG_FILE "$HOME/.config/wezterm/wezterm.lua"

# phpbrew
set -x PHPBREW_RC_ENABLE 1
source $HOME/.phpbrew/phpbrew.fish

# Added by `rbenv init`
status --is-interactive; and rbenv init - --no-rehash fish | source
