$ChocoPackages = @(
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

foreach ($package in $ChocoPackages)
{
    choco install $package
}

$WingetPackages = @(
    "eza-community.eza"
)

foreach ($package in $WingetPackages)
{
    winget install $package
}
