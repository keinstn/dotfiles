# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
dotfiles/
├── .claude/
│   ├── settings.json  # Claude Code settings
│   └── CLAUDE.md      # Global instructions
├── .config/
│   ├── cmux/
│   ├── fish/          # Fish shell
│   ├── ghostty/       # Ghostty terminal
│   ├── mcphub/
│   ├── nushell/       # Nushell
│   ├── nvim/          # Neovim
│   ├── starship.toml  # Starship prompt
│   ├── stylua.toml
│   ├── tmux/          # tmux
│   └── wezterm/       # WezTerm terminal
├── windows/           # Windows-specific configs
│   ├── PowerShell/
│   ├── WindowsTerminal/
│   ├── install.ps1
│   └── Invoke-Stow.ps1  # stow-equivalent linker
├── .gitconfig
├── brew.sh            # Homebrew packages
├── install.sh         # macOS setup script
└── .stow-local-ignore
```

Only git-tracked files are managed by Stow. Untracked files (history, cache, secrets) remain as real files in `~/.config/`.

## Setup

### macOS

```bash
git clone https://github.com/keinstn/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

`install.sh` runs the following steps:

1. Install Xcode Command Line Tools
2. Install Homebrew packages (`brew.sh`)
3. Apply dotfiles via `stow .`
4. Set Fish as default shell
5. Install Rust, Volta, and other tools

### Windows

```powershell
git clone https://github.com/keinstn/dotfiles.git ~/dotfiles
cd ~/dotfiles/windows
./install.ps1
```

`install.ps1` installs Chocolatey/winget packages and then runs
`Invoke-Stow.ps1`, which is the Windows equivalent of `stow .`.

It links every top-level entry in the repository into `$HOME` as a symbolic
link, honoring the same `.stow-local-ignore` file used on macOS, and follows
GNU Stow's "folding" rule: a directory is linked as a single symlink when no
directory of the same name already exists in `$HOME`; otherwise links are
created per-file inside the existing directory.

Prerequisites:

- **Developer Mode** must be enabled (Settings → Privacy & security → For
  developers), or the script must be run as Administrator. Without either,
  file symlinks cannot be created.
- Directory links fall back to junctions when symbolic-link creation is
  rejected.

Manual usage:

```powershell
# Sync (idempotent; existing real files are skipped with a warning)
./windows/Invoke-Stow.ps1

# Remove links previously created by this script (stow -D equivalent)
./windows/Invoke-Stow.ps1 -Mode Unstow

# Sync into a custom location (mainly for testing)
./windows/Invoke-Stow.ps1 -Target C:\tmp\fake-home
```

## Managing dotfiles

```bash
# Add a new config file
git add .config/sometool/config
git commit -m "[sometool] add config"
stow -R .

# Remove symlinks
stow -D .

# Re-apply symlinks
stow -R .
```

On Windows, use `Invoke-Stow.ps1` instead of `stow`:

```powershell
# Re-apply links after pulling changes
./windows/Invoke-Stow.ps1

# Remove links
./windows/Invoke-Stow.ps1 -Mode Unstow
```
