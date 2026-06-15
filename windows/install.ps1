$ChocoPackages = @(
    "awk",
    "bat",
    "delta",
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
    "eza-community.eza",
    "Microsoft.PowerShell",
    "Microsoft.Coreutils",
    "psmux"
)

foreach ($package in $WingetPackages)
{
    winget install $package
}

# Apply dotfiles via symbolic links (stow-equivalent)
& "$PSScriptRoot\Invoke-Stow.ps1"
