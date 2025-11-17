# My Dotfiles

Personal dotfiles managed with [chezmoi](https://chezmoi.io). Supports both personal and work-specific configurations through multiple source directories.

## Features

- 🏠 **Multi-source support**: Separate personal and work configurations
- 📦 **Automated package management**: Homebrew, Rust, npm, and more
- 🔧 **Version manager installation**: SDKMAN!, Volta, rustup
- 🎨 **Modern Unix tools**: bat, eza, ripgrep, fd, and many more
- ⌨️ **Editor configs**: Neovim, Vim, Doom Emacs, IntelliJ
- 🐚 **Shell configuration**: Zsh with starship prompt and modern completions
- 🤖 **Claude Code integration**: Pre-configured agents, commands, and contexts

## Quick Start

### Personal Machine

```bash
# Install chezmoi and apply dotfiles in one command
chezmoi init --apply https://github.com/jonbarksdale/dotfiles.git
```

### Work Machine (PayPal)

```bash
# Install personal dotfiles first
chezmoi init --apply https://github.com/jonbarksdale/dotfiles.git

# Clone work-specific configurations to a separate location
git clone git@github.paypal.com/jobarksdale/dotfiles-work.git ~/.local/share/chezmoi-work

# Create symlinks for work-specific files (these override personal configs)
ln -sf ~/.local/share/chezmoi-work/dot_zshrc_before ~/.zshrc_before
ln -sf ~/.local/share/chezmoi-work/dot_zshrc_local ~/.zshrc_local
ln -sf ~/.local/share/chezmoi-work/dot_gitconfig-local ~/.gitconfig-local
ln -sf ~/.local/share/chezmoi-work/dot_profile ~/.profile
mkdir -p ~/.local/bin
ln -sf ~/.local/share/chezmoi-work/dot_local/bin/executable_env ~/.local/bin/env
```

**Note**: Your personal `.zshrc` and `.gitconfig` are already configured to source these files if they exist, so the symlinks integrate seamlessly.

## What Gets Installed

### Package Managers & Tools

- **Homebrew**: Package manager with 80+ packages
- **Rustup**: Rust toolchain
- **SDKMAN!**: SDK version manager (Java, Kotlin, Groovy)
- **Volta**: Node.js version manager

### Development Tools

- **Editors**: Neovim, Vim, Doom Emacs, IntelliJ
- **Version Control**: Git with delta, GitHub CLI
- **Shells**: Zsh with starship prompt
- **Containers**: Docker (via Colima on work machines)

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

Work-specific files (PayPal):
- `~/.zshrc_before` - Proxy, certificates, environment
- `~/.zshrc_local` - Shell overrides, work functions
- `~/.gitconfig-local` - Work email, GitHub Enterprise
- `~/.profile` - PATH modifications
- `~/.local/bin/env` - PATH management

These files are provided by the work dotfiles repo (`~/.local/share/chezmoi-work`) and symlinked into your home directory. Your personal configs are already set up to source these files when they exist.

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

~/.local/share/chezmoi-work/     # Work dotfiles (optional)
├── dot_zshrc_before
├── dot_zshrc_local
├── dot_gitconfig-local
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

### Work configs not applying

```bash
# Verify both sources are configured
chezmoi source-path

# Check if work repo is initialized
ls -la ~/.local/share/chezmoi-work
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
