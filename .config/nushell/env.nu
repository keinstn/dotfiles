# env.nu
#
# Installed by:
# version = "0.104.0"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

$env.config.buffer_editor = "nvim"

# Prevent screen scrolling up when pressing a key
# See https://github.com/nushell/nushell/issues/5585#issuecomment-2663632002
$env.config.shell_integration.osc133 = false

# Integration with starship
$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ""

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ": "
$env.PROMPT_INDICATOR_VI_NORMAL = "〉"
$env.PROMPT_MULTILINE_INDICATOR = "::: "

$env.PATH ++= [$"($nu.home-path)/.local/bin"]

if $nu.os-info.name == "macos" {
    $env.PATH ++= ["/opt/homebrew/bin", "/Applications/Docker.app/Contents/Resources/bin", "/Applications/Amazon Q.app/Contents/MacOS/"]
}
