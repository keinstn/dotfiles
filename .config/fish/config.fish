source ~/.config/fish/aliases.fish

fish_vi_key_bindings

set -g simple_ass_prompt_greeting 

set -g FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'

source $HOME/.cargo/env

eval (direnv hook fish)
. (pyenv init - | psub)
