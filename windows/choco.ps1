$packages = @(
    "awk",
    "bat",
    "fd",
    "file",
    "gawk",
    "grep",
    "jq",
    "less",
    "lua-language-server",
    "make",
    "neovim",
    "nerd-fonts-Hack",
    "ripgrep",
    "sed",
    "sqlcmd",
    "starship",
    "tree"
)

foreach ($package in $packages)
{
    choco install $package
}
