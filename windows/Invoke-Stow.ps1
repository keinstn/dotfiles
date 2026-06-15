<#
.SYNOPSIS
    Stow-equivalent dotfiles synchronizer for Windows.

.DESCRIPTION
    Mirrors the behavior of `stow .` from the repository root into $HOME using
    symbolic links. Honors the same `.stow-local-ignore` file used on macOS so
    the ignore list remains a single source of truth across platforms.

    Implements stow-style "folding": when the target directory does not yet
    exist, the entire source directory is linked as a single symbolic link;
    when the target directory already exists, links are created per-file and
    intermediate directories are materialized as real directories.

.PARAMETER Mode
    Apply  - Create links (default).
    Unstow - Remove links previously created by Apply (equivalent to `stow -D`).

.PARAMETER Target
    Override the destination directory. Defaults to the user's profile
    directory ($HOME). Mainly useful for testing against an isolated location.

.EXAMPLE
    ./Invoke-Stow.ps1
    ./Invoke-Stow.ps1 -Mode Unstow
    ./Invoke-Stow.ps1 -Target C:\tmp\fake-home

.NOTES
    Creating symbolic links on Windows requires Developer Mode to be enabled
    or running as Administrator. Directory links fall back to junctions when
    symlink creation is not permitted; file links cannot fall back and will be
    skipped with a warning.
#>
[CmdletBinding()]
param(
    [ValidateSet('Apply', 'Unstow')]
    [string]$Mode = 'Apply',

    [string]$Target = [Environment]::GetFolderPath('UserProfile')
)

$ErrorActionPreference = 'Stop'

$script:RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if (-not (Test-Path -LiteralPath $Target)) {
    New-Item -ItemType Directory -Path $Target -Force | Out-Null
}
$script:Target   = (Resolve-Path -LiteralPath $Target).Path
$script:Stats    = [ordered]@{
    Created = 0
    Removed = 0
    Skipped = 0
    Errors  = 0
}

function Get-IgnorePatterns {
    $ignoreFile = Join-Path $script:RepoRoot '.stow-local-ignore'
    if (-not (Test-Path -LiteralPath $ignoreFile)) {
        return @()
    }
    Get-Content -LiteralPath $ignoreFile |
        ForEach-Object { $_.Trim() } |
        Where-Object { $_ -and -not $_.StartsWith('#') }
}

function Get-RelativePosixPath {
    param([string]$FullPath)
    $rel = [System.IO.Path]::GetRelativePath($script:RepoRoot, $FullPath)
    '/' + ($rel -replace '\\', '/')
}

function Test-IsIgnored {
    param(
        [string]$RelativePosixPath,
        [string[]]$Patterns
    )
    foreach ($p in $Patterns) {
        if ($RelativePosixPath -match $p) { return $true }
        # stow matches prefixes for directories; emulate by also testing trailing slash
        if (("$RelativePosixPath/") -match $p) { return $true }
    }
    return $false
}

function Get-LinkTargetPath {
    param([System.IO.FileSystemInfo]$Item)
    if ($null -eq $Item) { return $null }
    # PowerShell 5.1+ exposes .Target on reparse points
    $t = $Item.Target
    if ($t) {
        if ($t -is [array]) { return $t[0] }
        return [string]$t
    }
    return $null
}

function Resolve-FullPathSafe {
    param([string]$Path)
    try {
        return [System.IO.Path]::GetFullPath($Path)
    } catch {
        return $Path
    }
}

function New-DirectoryLink {
    param(
        [string]$SourcePath,
        [string]$TargetPath
    )
    try {
        New-Item -ItemType SymbolicLink -Path $TargetPath -Value $SourcePath -ErrorAction Stop | Out-Null
        return $true
    } catch {
        Write-Verbose "SymbolicLink failed for ${TargetPath}: $($_.Exception.Message). Falling back to Junction."
        try {
            New-Item -ItemType Junction -Path $TargetPath -Value $SourcePath -ErrorAction Stop | Out-Null
            return $true
        } catch {
            Write-Warning "Failed to create directory link ${TargetPath}: $($_.Exception.Message)"
            $script:Stats.Errors++
            return $false
        }
    }
}

function New-FileLink {
    param(
        [string]$SourcePath,
        [string]$TargetPath
    )
    try {
        New-Item -ItemType SymbolicLink -Path $TargetPath -Value $SourcePath -ErrorAction Stop | Out-Null
        return $true
    } catch {
        Write-Warning "Failed to create file link ${TargetPath}: $($_.Exception.Message). (Enable Developer Mode or run as Administrator.)"
        $script:Stats.Errors++
        return $false
    }
}

function Invoke-ApplyEntry {
    param(
        [System.IO.FileSystemInfo]$SourceItem,
        [string]$TargetPath,
        [string[]]$Patterns
    )

    $sourceFull = Resolve-FullPathSafe $SourceItem.FullName
    $targetFull = Resolve-FullPathSafe $TargetPath

    if (Test-Path -LiteralPath $targetFull) {
        $existing = Get-Item -LiteralPath $targetFull -Force
        $isLink = $existing.Attributes -band [IO.FileAttributes]::ReparsePoint
        if ($isLink) {
            $linkTarget = Get-LinkTargetPath $existing
            if ($linkTarget) {
                $linkFull = Resolve-FullPathSafe $linkTarget
                if ($linkFull -and ($linkFull.TrimEnd('\','/') -ieq $sourceFull.TrimEnd('\','/'))) {
                    Write-Verbose "Already linked: $targetFull"
                    return
                }
            }
            Write-Warning "Skip: $targetFull is a link to a different target."
            $script:Stats.Skipped++
            return
        }

        if ($SourceItem.PSIsContainer -and $existing.PSIsContainer) {
            # Recurse: target dir already exists as a real directory.
            foreach ($child in Get-ChildItem -LiteralPath $sourceFull -Force) {
                $childRel = Get-RelativePosixPath $child.FullName
                if (Test-IsIgnored $childRel $Patterns) { continue }
                $childTarget = Join-Path $targetFull $child.Name
                Invoke-ApplyEntry -SourceItem $child -TargetPath $childTarget -Patterns $Patterns
            }
            return
        }

        Write-Warning "Skip: $targetFull already exists and is not a link."
        $script:Stats.Skipped++
        return
    }

    # Target does not exist: ensure parent dir, then link as a single entry (folding for dirs).
    $parent = Split-Path -Parent $targetFull
    if ($parent -and -not (Test-Path -LiteralPath $parent)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }

    if ($SourceItem.PSIsContainer) {
        if (New-DirectoryLink -SourcePath $sourceFull -TargetPath $targetFull) {
            Write-Host "Linked dir : $targetFull -> $sourceFull"
            $script:Stats.Created++
        }
    } else {
        if (New-FileLink -SourcePath $sourceFull -TargetPath $targetFull) {
            Write-Host "Linked file: $targetFull -> $sourceFull"
            $script:Stats.Created++
        }
    }
}

function Invoke-UnstowEntry {
    param(
        [System.IO.FileSystemInfo]$SourceItem,
        [string]$TargetPath,
        [string[]]$Patterns
    )

    $sourceFull = Resolve-FullPathSafe $SourceItem.FullName
    $targetFull = Resolve-FullPathSafe $TargetPath

    if (-not (Test-Path -LiteralPath $targetFull)) { return }

    $existing = Get-Item -LiteralPath $targetFull -Force
    $isLink = $existing.Attributes -band [IO.FileAttributes]::ReparsePoint

    if ($isLink) {
        $linkTarget = Get-LinkTargetPath $existing
        if ($linkTarget) {
            $linkFull = Resolve-FullPathSafe $linkTarget
            if ($linkFull -and ($linkFull.TrimEnd('\','/') -ieq $sourceFull.TrimEnd('\','/'))) {
                try {
                    if ($existing.PSIsContainer) {
                        # SymbolicLink dir / Junction
                        [System.IO.Directory]::Delete($targetFull, $false)
                    } else {
                        Remove-Item -LiteralPath $targetFull -Force -ErrorAction Stop
                    }
                    Write-Host "Removed    : $targetFull"
                    $script:Stats.Removed++
                } catch {
                    Write-Warning "Failed to remove ${targetFull}: $($_.Exception.Message)"
                    $script:Stats.Errors++
                }
                return
            }
        }
        # Link points elsewhere: leave it alone.
        return
    }

    if ($SourceItem.PSIsContainer -and $existing.PSIsContainer) {
        foreach ($child in Get-ChildItem -LiteralPath $sourceFull -Force) {
            $childRel = Get-RelativePosixPath $child.FullName
            if (Test-IsIgnored $childRel $Patterns) { continue }
            $childTarget = Join-Path $targetFull $child.Name
            Invoke-UnstowEntry -SourceItem $child -TargetPath $childTarget -Patterns $Patterns
        }
        # Remove the directory if it became empty (only if we created it as a real dir).
        if (-not (Get-ChildItem -LiteralPath $targetFull -Force)) {
            try {
                Remove-Item -LiteralPath $targetFull -Force -ErrorAction Stop
                Write-Verbose "Cleaned empty dir: $targetFull"
            } catch {
                # Non-fatal: directory may have other siblings or perms issues.
                Write-Verbose "Could not remove ${targetFull}: $($_.Exception.Message)"
            }
        }
    }
}

function Invoke-Sync {
    param([string]$Mode)

    $patterns = @(Get-IgnorePatterns)
    Write-Verbose "Repo root: $script:RepoRoot"
    Write-Verbose "Target   : $script:Target"
    Write-Verbose ("Ignore patterns: " + ($patterns -join ', '))

    foreach ($entry in Get-ChildItem -LiteralPath $script:RepoRoot -Force) {
        $rel = Get-RelativePosixPath $entry.FullName
        if (Test-IsIgnored $rel $patterns) {
            Write-Verbose "Ignored: $rel"
            continue
        }
        $targetPath = Join-Path $script:Target $entry.Name
        switch ($Mode) {
            'Apply'  { Invoke-ApplyEntry  -SourceItem $entry -TargetPath $targetPath -Patterns $patterns }
            'Unstow' { Invoke-UnstowEntry -SourceItem $entry -TargetPath $targetPath -Patterns $patterns }
        }
    }
}

Invoke-Sync -Mode $Mode

Write-Host ""
Write-Host "=== Invoke-Stow summary ($Mode) ==="
foreach ($k in $script:Stats.Keys) {
    Write-Host ("  {0,-8}: {1}" -f $k, $script:Stats[$k])
}

if ($script:Stats.Errors -gt 0) { exit 1 }
