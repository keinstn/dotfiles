# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
dotfiles/
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
│   └── WindowsTerminal/
├── .gitconfig
├── .direnvrc
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
