$ChocoPackages = @(
    "awk",
    "bat",
    "difftastic",
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
    "pass-winmenu",
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
