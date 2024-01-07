source ~/.config/fish/aliases.fish

fish_vi_key_bindings

set -g simple_ass_prompt_greeting

set -g FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'

set -x PATH "/opt/homebrew/bin" $PATH
eval (brew shellenv)

if not type -q brew
    set -x PATH "$HOME/.local/bin" $PATH
    set -x PATH "$HOME/.yarn/bin" $PATH
end

set -x PATH "$HOME/.cargo/bin" $PATH

set -x PATH "$HOME/go/bin" $PATH

set -x PATH "/usr/local/opt/llvm/bin" $PATH

eval (direnv hook fish)

starship init fish | source

# flutter
set -x PATH "$HOME/.pub-cache/bin" $PATH

set -x WEZTERM_CONFIG_FILE "$HOME/.config/wezterm/wezterm.lua"

set -Ua fish_user_paths "$HOME/.rye/shims"

# phpbrew
set -x PHPBREW_RC_ENABLE 1
source $HOME/.phpbrew/phpbrew.fish
