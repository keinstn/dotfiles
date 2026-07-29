# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure

```
dotfiles/
├── agent-rules/        # Source of truth for portable agent instructions
├── .claude/
│   └── rules/         # Generated Claude Code instructions
├── .codex/
│   └── AGENTS.md      # Generated Codex global instructions
├── .copilot/
│   └── copilot-instructions.md  # Generated GitHub Copilot CLI instructions
├── .config/
│   ├── fish/          # Fish shell
│   ├── ghostty/       # Ghostty terminal
│   ├── mcphub/
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

Git-tracked files and renderer-generated instruction files are managed by
Stow. Other untracked files (history, cache, secrets) remain as real files in
`~/.config/`.

## Agent instructions

`agent-rules/` is the single source of truth for portable coding-agent
guidance. The renderer creates tool-specific files for Claude Code, Codex, and
GitHub Copilot CLI:

```bash
./scripts/render-agent-rules
stow -R .
```

`install.sh` and `windows/install.ps1` run the Bash renderer before linking
files. The generated files are intentionally ignored by Git; edit
`agent-rules/`, not `.claude/rules/`, `.codex/AGENTS.md`, or
`.copilot/copilot-instructions.md`.

GitHub Copilot CLI discovers the generated instructions at its standard
user-level path, `~/.copilot/copilot-instructions.md`. Other Copilot surfaces
use different instruction locations, so add a renderer target for the specific
IDE or GitHub feature when needed.

Stow does not replace an existing real instruction file. If a machine already
has local guidance at `~/.codex/AGENTS.md` or under `~/.claude/rules/`, merge
or move it first, then rerun the render and Stow commands.

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
3. Render agent instructions and apply dotfiles via `stow .`
4. Set Fish as default shell
5. Install Rust, Volta, and other tools

### Windows

```powershell
git clone https://github.com/keinstn/dotfiles.git ~/dotfiles
cd ~/dotfiles/windows
./install.ps1
```

`install.ps1` installs Chocolatey/winget packages and then runs
the Bash renderer followed by `Invoke-Stow.ps1`, which is the Windows
equivalent of `stow .`. Git Bash is required; the installer invokes
`C:\Program Files\Git\bin\bash.exe` or
`C:\Program Files (x86)\Git\bin\bash.exe` directly, rather than resolving
`bash` from `PATH`.

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

## Terminal splits mode

`terminal-splits` resolves keybinding conflicts between ghostty/wezterm and tmux, both of which use `Ctrl+Q` as a leader/prefix and `Ctrl+H/J/K/L` for pane navigation.

| Mode | Who handles splits and navigation |
|------|----------------------------------|
| ON | ghostty / wezterm (`Ctrl+Q` leader, `Ctrl+H/J/K/L` movement) |
| OFF | tmux (`Ctrl+Q` passes through as tmux prefix) |

```bash
terminal-splits on      # ghostty/wezterm handles splits
terminal-splits off     # tmux handles splits
terminal-splits toggle  # switch between modes
terminal-splits status  # show current mode
```

Available in fish, and PowerShell.

**First-time setup (run once after `stow .`):**

```bash
terminal-splits on   # or off
```

- **wezterm**: reloads automatically when the marker file changes
- **ghostty**: requires a manual reload via `Shift+Cmd+,` or Ghostty > Reload Configuration

Mode state is tracked by `~/.config/terminal-splits-on` (file exists = ON).
The ghostty keybinding file (`~/.config/ghostty/splits.ghostty`) is a runtime symlink managed by the toggle command and is excluded from git.

## Managing dotfiles

```bash
# Add a new config file
git add .config/sometool/config
git commit -m "[sometool] add config"
./scripts/render-agent-rules
stow -R .

# Remove symlinks
stow -D .

# Re-apply symlinks
stow -R .
```

On Windows, use `Invoke-Stow.ps1` instead of `stow`:

```powershell
# Re-apply links after pulling changes
bash ./scripts/render-agent-rules
./windows/Invoke-Stow.ps1

# Remove links
./windows/Invoke-Stow.ps1 -Mode Unstow
```
