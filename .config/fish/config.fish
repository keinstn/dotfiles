source ~/.config/fish/aliases.fish

fish_vi_key_bindings

set -g simple_ass_prompt_greeting

set -g FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'

source $HOME/.cargo/env

if not type -q brew
    set -x PATH "$HOME/.pyenv/bin" $PATH
    set -x PATH "$HOME/.local/bin" $PATH
    set -x PATH "$HOME/.yarn/bin" $PATH
end

set -x PATH "$HOME/go/bin" $PATH

set -x PATH "/usr/local/opt/llvm/bin" $PATH

eval (direnv hook fish)
source (pyenv init --path | psub)

status --is-interactive; and source (rbenv init -|psub)

set -x PHPENV_ROOT "$HOME/.phpenv"
if test -d "$HOME/.phpenv"
    set -x PATH "$HOME/.phpenv/bin" $PATH
    status --is-interactive; and . (phpenv init -|psub)
end

starship init fish | source

# flutter
set -x PATH "$HOME/.pub-cache/bin" $PATH
