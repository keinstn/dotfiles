$profile_dir = (Split-Path -Path $PROFILE -Parent -Resolve)

Import-Module "$profile_dir\Aliases.ps1"
Import-Module "$profile_dir\Functions.ps1"

$env:Path = "$HOME\.cargo\bin;$env:Path"
$env:PATH = "$HOME\.local`\bin;$env:PATH"

[Console]::OutputEncoding = [System.Text.Encoding]::GetEncoding('utf-8')

Invoke-Expression (&starship init powershell)

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile))
{
    Import-Module "$ChocolateyProfile"
}
