function ll
{ 
    eza.exe -lh --git @args 
}

function vimdiff
{ 
    nvim -d @args 
}

function open
{
    Invoke-Item $args
}

function touch
{
    New-Item $args
}

function cut
{
    param(
        [Parameter(ValueFromPipeline=$True)] [string]$inputobject,
        [string]$delimiter='\s+',
        [string[]]$field
    )

    process
    {
        if ($null -eq $field)
        { 
            $inputobject -split $delimiter 
        } else
        {
            ($inputobject -split $delimiter)[$field] 
        }
    }
}

function New-Link ($target, $link)
{
    New-Item -Path $link -ItemType SymbolicLink -Value $target
}

function Set-TerminalSplits {
    param([ValidateSet('on','off','toggle','status')][string]$Action = 'toggle')
    $marker = Join-Path $HOME ".config\terminal-splits-on"
    $wez    = Join-Path $HOME ".config\wezterm\wezterm.lua"
    $is_on  = Test-Path $marker

    switch ($Action) {
        'status' { Write-Host (if ($is_on) { "terminal-splits: ON" } else { "terminal-splits: OFF (tmux mode)" }) }
        'on'     { if ($is_on) { Write-Host "already ON"; return } ; _TS-Apply on  $marker $wez }
        'off'    { if (-not $is_on) { Write-Host "already OFF"; return } ; _TS-Apply off $marker $wez }
        'toggle' { if ($is_on) { _TS-Apply off $marker $wez } else { _TS-Apply on $marker $wez } }
    }
}
Set-Alias terminal-splits Set-TerminalSplits

function _TS-Apply ($mode, $marker, $wez) {
    if ($mode -eq 'on') {
        New-Item -ItemType File -Path $marker -Force | Out-Null
        Write-Host "terminal-splits: ON"
    } else {
        Remove-Item $marker -ErrorAction SilentlyContinue
        Write-Host "terminal-splits: OFF (tmux mode)"
    }
    if (Test-Path $wez) { (Get-Item $wez).LastWriteTime = Get-Date }
    Write-Host "  wezterm: reloading automatically"
}
