# Dotbot to Chezmoi Migration Guide

This document describes the migration from dotbot to chezmoi for managing dotfiles.

## Migration Overview

### What Changed

1. **Package manager**: dotbot → chezmoi
2. **File organization**: Flat structure → chezmoi naming conventions (`dot_` prefix)
3. **Installation scripts**: Dotbot plugins → chezmoi scripts (`.chezmoiscripts/`)
4. **Configuration**: `install.conf.yaml` → `.chezmoi.yaml.tmpl`
5. **Work configs**: Separate manual management → Multi-source chezmoi directories

### What Stayed the Same

1. **Zsh sourcing hooks**: Still uses `~/.zshrc_before`, `~/.zshrc_local`, etc.
2. **Git includes**: Still uses `~/.gitconfig-local`
3. **Package lists**: Same Homebrew packages, Rust crates, etc.
4. **File locations**: Everything still goes to the same place in `~/`

## File Mapping

### Dotbot Structure

```
dotfiles/
├── install                      # Installation script
├── install.conf.yaml            # Configuration
├── dotbot/                      # Dotbot submodule
├── dotbot-*/                    # Plugin submodules
├── zsh/
│   └── zshrc
├── git/
│   └── config
└── ...
```

### Chezmoi Structure

```
dotfiles/
├── .chezmoi.yaml.tmpl           # Configuration
├── .chezmoiignore              # Files to ignore
├── .chezmoiscripts/            # Installation scripts
│   ├── run_once_before_*
│   └── run_after_*
├── dot_zshrc                   # Moved from zsh/zshrc
├── dot_config/
│   └── git/
│       └── config              # Moved from git/config
└── ...
```

## Dotbot Features → Chezmoi Equivalents

| Dotbot Feature | Chezmoi Equivalent |
|----------------|-------------------|
| Symlinks | Copy mode (default) or symlink mode |
| Directories | `dot_` prefix for directories |
| Clean | `.chezmoiignore` + chezmoi's built-in cleaning |
| Shell commands | `.chezmoiscripts/run_*.sh` |
| dotbot-brew | Brewfile + `run_once_before_brew-bundle.sh` |
| dotbot-rust | `run_once_before_install-rust.sh` |
| dotbot-gh-extension | `run_once_before_install-gh-extensions.sh` |

## Installation Script Mapping

### Dotbot (`install.conf.yaml`)

```yaml
- shell:
  - command: git submodule update --init --recursive
  - command: ~/.emacs.d/bin/doom env
  - command: ~/.emacs.d/bin/doom sync
  - command: curl -s "https://get.sdkman.io?rcupdate=false" | bash
    condition: '(( $+functions[sdk] )) || command'
  - command: curl https://get.volta.sh | bash -s -- --skip-setup
    condition: command -v volta
  - command: mas upgrade

- brew:
    install-brew: true
- brewfile: Brewfile
- cargo:
    - choose
    - rm-improved
    - tokei --all-features
    - xcp
    - whyq
- ghe:
    - github/gh-copilot
```

### Chezmoi Scripts

1. `run_once_before_10-install-homebrew.sh.tmpl` - Install Homebrew
2. `run_once_before_20-brew-bundle.sh.tmpl` - Install from Brewfile
3. `run_once_before_30-install-rust.sh.tmpl` - Install Rust + cargo packages
4. `run_once_before_40-install-gh-extensions.sh.tmpl` - Install gh extensions
5. `run_once_install-sdkman.sh` - Install SDKMAN!
6. `run_once_install-volta.sh` - Install Volta
7. `run_after_10-doom-sync.sh.tmpl` - Sync Doom Emacs
8. `run_after_20-mas-upgrade.sh` - Upgrade Mac App Store apps

**Script naming conventions:**
- `run_once_before_*` - Run before applying files (package installation)
- `run_once_*` - Run once at any time
- `run_after_*` - Run after applying files (post-configuration)
- Numbered (`10-`, `20-`, etc.) - Control execution order
- `.tmpl` suffix - Template files (can use chezmoi variables)

## Multi-Source Configuration

### Dotbot Approach

Work-specific files manually created and maintained on each machine:
- `~/.zshrc_before` (manually created)
- `~/.zshrc_local` (manually created)
- `~/.gitconfig-local` (manually created)

### Chezmoi Approach

Work-specific files managed in a separate git repository and symlinked:

**Personal repo** (`~/.local/share/chezmoi/`):
- Contains `dot_zshrc` which sources `~/.zshrc_before` and `~/.zshrc_local`
- Contains `dot_config/git/config` which includes `~/.gitconfig-local`

**Work repo** (`~/.local/share/chezmoi-work/`):
- Provides `dot_zshrc_before`, `dot_zshrc_local`, `dot_gitconfig-local`, etc.
- These are **symlinked** into `~/` (e.g., `~/.zshrc_local` → `~/.local/share/chezmoi-work/dot_zshrc_local`)

On personal machines: Only the personal repo is cloned; the sourced files don't exist (which is fine).
On work machines: Both repos are cloned, work files are symlinked, and personal configs source them.

## Migration Steps Performed

1. ✅ Created `.chezmoi.yaml.tmpl` with multi-source configuration
2. ✅ Created `.chezmoiignore` to exclude non-dotfile content
3. ✅ Generated `dot_Brewfile` from dotbot brew configuration
4. ✅ Created installation scripts in `.chezmoiscripts/`
5. ✅ Renamed all dotfiles to chezmoi conventions (using `git mv`)
6. ✅ Created work dotfiles repository with template files
7. ✅ Removed dotbot submodules and `install.conf.yaml`
8. ✅ Updated documentation

## Workflow Changes

### Before (Dotbot)

```bash
# Edit files in place (symlinked to repo)
vim ~/.zshrc

# Commit changes directly from repo
cd ~/.dotfiles
git commit -am "Update zsh config"
git push

# On other machines
cd ~/.dotfiles
git pull
./install
```

### After (Chezmoi)

```bash
# Edit files in place (copied to ~/)
vim ~/.zshrc

# Capture changes to chezmoi source
chezmoi add ~/.zshrc

# Commit from source directory
chezmoi cd
git commit -am "Update zsh config"
git push

# On other machines
chezmoi update
```

**Alternative workflow** (edit in source):

```bash
# Edit directly in chezmoi source
chezmoi edit ~/.zshrc

# Apply changes
chezmoi apply

# Commit and push
chezmoi cd
git commit -am "Update zsh config"
git push
```

## Benefits of Migration

### Better Multi-Machine Support

- Templates for per-machine customization
- Multi-source directories for work/personal separation
- Built-in machine identification

### Improved Installation

- Idempotent scripts with `run_once_*`
- Clear execution order with numbered prefixes
- Better error handling and status messages

### Version Management

- Can track package versions in templates
- Easier to reproduce exact environment on new machines
- Better documentation of what's installed

### Simpler Maintenance

- No submodules to manage
- Standard git workflow
- Built-in diff and apply commands

## Rollback Plan

If you need to roll back to dotbot:

1. Checkout the last commit before migration
2. Run `git submodule update --init --recursive`
3. Run `./install`

The commit message for the migration will be clearly marked for easy identification.

## Testing the Migration

### Dry Run

```bash
# See what chezmoi would do without making changes
chezmoi apply --dry-run --verbose
```

### Verification Checklist

- [ ] All expected dotfiles present in `~/`
- [ ] Homebrew packages installed (check with `brew list`)
- [ ] Rust and cargo packages installed (check with `cargo install --list`)
- [ ] GitHub CLI extensions installed (check with `gh extension list`)
- [ ] SDKMAN! functional (check with `sdk version`)
- [ ] Volta functional (check with `volta --version`)
- [ ] Doom Emacs synced (check with `doom doctor`)
- [ ] Shell configuration working (restart shell and test)
- [ ] Git configuration correct (check with `git config --list`)
- [ ] Work configs applied on work machine (if applicable)

## Frequently Asked Questions

### Q: Can I still edit files directly in my home directory?

**A:** Yes! Edit files wherever you like. Just remember to run `chezmoi add <file>` to capture changes back to the source before committing.

### Q: What happens to my existing dotfiles when I run `chezmoi apply`?

**A:** Chezmoi will copy files from the source directory to your home directory. Existing files will be overwritten. Use `--dry-run` to preview changes first.

### Q: How do I add work-specific config on a work machine?

**A:** After initial setup, clone the work repo and create symlinks:
```bash
# Clone work configs
git clone git@github.paypal.com/jobarksdale/dotfiles-work.git ~/.local/share/chezmoi-work

# Create symlinks
ln -sf ~/.local/share/chezmoi-work/dot_zshrc_before ~/.zshrc_before
ln -sf ~/.local/share/chezmoi-work/dot_zshrc_local ~/.zshrc_local
ln -sf ~/.local/share/chezmoi-work/dot_gitconfig-local ~/.gitconfig-local
ln -sf ~/.local/share/chezmoi-work/dot_profile ~/.profile
mkdir -p ~/.local/bin
ln -sf ~/.local/share/chezmoi-work/dot_local/bin/executable_env ~/.local/bin/env
```

### Q: Can I use symlink mode instead of copy mode?

**A:** Yes, but it's not recommended for this setup. Copy mode allows for template support and per-machine customization. To enable symlink mode, add `mode: symlink` to `.chezmoi.yaml`.

### Q: What if I want to customize for a specific machine?

**A:** Use chezmoi templates! Files with `.tmpl` extension can include machine-specific logic. See the [chezmoi documentation](https://www.chezmoi.io/user-guide/templating/) for details.

## Additional Resources

- [Chezmoi documentation](https://www.chezmoi.io/)
- [Chezmoi quick start](https://www.chezmoi.io/quick-start/)
- [Chezmoi user guide](https://www.chezmoi.io/user-guide/)
- [Work dotfiles README](../workspace/dotfiles-work/README.md)
