# My Dotfiles

Personal dotfiles managed with [chezmoi](https://chezmoi.io). Supports both personal and work-specific configurations through multiple source directories.

## Features

- 🏠 **Multi-source support**: Separate personal and work configurations
- 📦 **Automated package management**: Homebrew, Rust, and more
- 🔧 **Version management**: mise (Java, Node.js, Go, etc.) and rustup
- 🎨 **Modern Unix tools**: bat, eza, ripgrep, fd, and many more
- ⌨️ **Editor configs**: Neovim, Vim, Doom Emacs
- 🐚 **Shell configuration**: Zsh with starship prompt and modern completions
- 🤖 **Claude Code integration**: Pre-configured agents, commands, and contexts

## Quick Start

### Prerequisites

On a fresh macOS machine:

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install chezmoi
brew install chezmoi
```

### Personal Machine

```bash
# Initialize and apply dotfiles
chezmoi init --apply https://github.com/jonbarksdale/dotfiles.git
```

Alternatively, use chezmoi's one-liner (installs chezmoi temporarily):
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply jonbarksdale/dotfiles
```

### Work Machine

```bash
# Install personal dotfiles first
chezmoi init --apply https://github.com/jonbarksdale/dotfiles.git

# Clone work-specific configurations to a separate location
# (Replace with your work dotfiles repository)
git clone <work-dotfiles-repo> ~/.local/share/dotfiles-work

# Run work dotfiles setup script
cd ~/.local/share/dotfiles-work
./setup.sh
```

**Note**: Your personal `.zshrc` and `.gitconfig` are already configured to source work-specific override files (`~/.zshrc_local`, `~/.gitconfig-local`) if they exist, so the work configuration integrates seamlessly.

## Machine-Specific Configuration

After `chezmoi init`, create `~/.config/chezmoi/chezmoi.yaml` to configure machine-specific behavior:

```yaml
diff:
  pager: "delta"

git:
  autoCommit: false
  autoPush: false

data:
  # Set to true on machines with a Claude Max subscription.
  # Controls whether session usage, weekly usage, and reset timer
  # widgets appear in the ccstatusline status bar.
  hasClaudeSubscription: true   # or false for work/no-subscription machines
```

| Variable | Values | Effect |
|----------|--------|--------|
| `hasClaudeSubscription` | `true` / `false` | Show/hide Claude usage widgets in status line |

## What Gets Installed

### Package Managers & Tools

- **Homebrew**: Package manager with 80+ packages
- **Rustup**: Rust toolchain
- **mise**: Development tool version manager (Java, Node.js, Go, Bun, Maven, Gradle)

### Development Tools

- **Editors**: Neovim, Vim, Doom Emacs
- **Version Control**: Git with delta, GitHub CLI
- **Shells**: Zsh with starship prompt
- **Containers**: Docker, Colima

### Modern Unix Replacements

| Traditional | Modern Alternative |
|-------------|-------------------|
| ls          | eza, lsd, pls |
| find        | fd |
| grep        | ripgrep |
| cat         | bat |
| top         | bottom, htop |
| du          | dust |
| ps          | procs |
| sed         | sd |
| df          | duf |

### Cloud & Infrastructure

- kubectl, awscli, aws-vault, localstack
- Network tools: httpie, curlie, xh, doggo, mtr

### Data Processing

- jq, jless, gron, fx, whyq (YAML)

## Daily Workflow

### Editing Configuration

Edit files naturally in their normal locations:

```bash
# Edit your zsh config
vim ~/.zshrc

# Edit neovim config
vim ~/.config/nvim/init.lua
```

### Syncing Changes

After editing, capture and sync your changes:

```bash
# See what changed
chezmoi status

# Review changes before committing
chezmoi diff

# Capture changes
chezmoi add ~/.zshrc ~/.config/nvim

# Commit and push (from the source directory)
chezmoi cd
git add -A
git commit -m "Update shell configuration"
git push
```

### Updating Other Machines

On your other machines:

```bash
# Pull latest changes and apply
chezmoi update
```

## Work-Specific Configuration

The personal dotfiles support composition with work-specific configurations via hook files:
- `~/.zshrc_before` - Sourced at the start of shell initialization
- `~/.zshrc_local` - Sourced at the end of shell initialization
- `~/.gitconfig-local` - Included by git config (last wins)
- `~/.profile` - Shell-agnostic environment setup

These files are optional and sourced only if they exist. If you need work-specific overrides, maintain them in a separate work dotfiles repository and use its setup script to create symlinks.

## Directory Structure

```
~/.local/share/chezmoi/          # Personal dotfiles (this repo)
├── .chezmoiscripts/             # Installation scripts
│   ├── run_once_before_*        # Package installation
│   └── run_after_*              # Post-installation setup
├── dot_config/                  # XDG config files
│   ├── nvim/                    # Neovim configuration
│   ├── git/                     # Git configuration
│   ├── yazi/                    # File manager config
│   └── ...
├── dot_zshrc                    # Zsh configuration
├── dot_Brewfile                 # Homebrew packages
└── ...

~/.local/share/dotfiles-work/    # Work dotfiles (optional, separate repo)
├── dot_zshrc_before             # Work environment setup
├── dot_zshrc_local              # Work shell overrides
├── dot_gitconfig-local          # Work git configuration
├── setup.sh                     # Creates symlinks to home directory
└── ...
```

## Fonts

All Nerd Fonts are installed automatically via Homebrew:
- Victor Mono NF
- Meslo LG NF (recommended for powerline)
- JetBrains Mono NF
- Fira Code NF
- Cascadia Mono NF
- Monaspace NF
- And more...

Plus math fonts:
- Latin Modern Math
- STIX Two Math
- Noto family (emoji, sans, symbols)

## Troubleshooting

### View what chezmoi would do

```bash
chezmoi apply --dry-run --verbose
```

### Force re-run installation scripts

```bash
# Remove chezmoi state to re-run scripts
rm -rf ~/.local/share/chezmoi/.chezmoistate

# Re-apply
chezmoi apply
```

### Check chezmoi configuration

```bash
chezmoi doctor
```

### Work configs not loading

```bash
# Check if work override files exist and are symlinked
ls -la ~/.zshrc_local ~/.gitconfig-local

# Verify work repo is present
ls -la ~/.local/share/dotfiles-work
```

## Migration from dotbot

This repo was previously managed with dotbot. The migration to chezmoi preserves all functionality while providing:
- Better multi-machine support
- Template support for per-machine customization
- Built-in git integration
- Simpler installation scripts
- Better documentation

See `docs/CHEZMOI_MIGRATION.md` for details on the migration process.

## Contributing

These are personal dotfiles, but feel free to use them as inspiration for your own setup!

## License

MIT
