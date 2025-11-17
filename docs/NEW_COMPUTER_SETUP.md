# New Computer Setup Guide

ABOUTME: Complete guide for setting up a new work computer from scratch using
ABOUTME: this dotfiles repository.

## Setup Checklist

### Pre-Installation

- [ ] Complete macOS setup wizard and configure system preferences
- [ ] Sign in to iCloud and enable iCloud Drive
- [ ] Install 1Password and verify sync
- [ ] Install corporate VPN and security software
- [ ] Install Xcode Command Line Tools: `xcode-select --install`

### Installation

- [ ] Clone dotfiles repository
- [ ] Review install script and configuration
- [ ] Run `./install`
- [ ] Restart shell or open new terminal

### Post-Installation

- [ ] Create local config files (~/.gitconfig-local, ~/.zshrc_local, etc.)
- [ ] Configure Spotlight for ~/Applications
- [ ] Verify Doom Emacs: `~/.emacs.d/bin/doom doctor`
- [ ] Install corporate-required tool versions (Java, Maven, etc.)

### Data Migration

- [ ] Restore SSH and GPG keys
- [ ] Transfer ~/org files
- [ ] Restore version manager state (use `./scripts/install-versions.sh`)
- [ ] Transfer active projects
- [ ] Import IDE and browser settings

### Verification

- [ ] Test development tools (java, node, python, git)
- [ ] Verify SSH/GPG signing works
- [ ] Build a project to confirm environment

## Pre-Installation Setup

### macOS Configuration

Configure system preferences:

- Trackpad: Enable tap to click, configure gestures
- Keyboard: Set key repeat rate, disable auto-correct
- Dock: Auto-hide, position, size
- Desktop & Screen Saver: Set preferences

### Critical Applications

**iCloud Drive**

- Enable iCloud Drive in System Settings
- Wait for initial sync (check ~/Library/Mobile Documents/)

**1Password**

- Download from [1password.com](https://1password.com/downloads/mac/)
- Sign in and verify vaults accessible
- Enable browser extension
- Test SSH key access

**Corporate Tools**

- Install VPN and connect
- Install required security/management software
- Verify network connectivity

**Setapp (Optional)**

If you use Setapp subscription:

- Download from [setapp.com](https://setapp.com)
- Sign in to your account
- Apps will be available to install on-demand or reinstall from old machine list

**Command Line Tools**

```bash
xcode-select --install
```

Wait for completion before proceeding.

## Dotfiles Installation

### Clone Repository

```bash
mkdir -p ~/developer/COMPANY  # Adjust path as needed
cd ~/developer/COMPANY
git clone git@github.com:YOUR_USERNAME/dotfiles.git
```

If SSH not configured, use HTTPS initially.

### Run Installation

```bash
cd dotfiles
./install
```

**Duration**: 30-60 minutes depending on network speed.

**What happens**:

- Updates git submodules (dotbot, plugins, doom-emacs)
- Creates directories including ~/Applications
- Creates config file symlinks
- Installs Homebrew
- Installs ~150 brew packages
- Installs ~40 cask applications to ~/Applications
- Installs 20+ Nerd Fonts
- Installs Emacs Plus with native compilation
- Installs Rust toolchain and cargo packages
- Sets up Doom Emacs
- Installs SDKMAN!, Volta version managers
- Installs GitHub Copilot CLI extension
- Upgrades Mac App Store apps

Re-run `./install` if any step fails (it's idempotent).

### Restart Shell

```bash
exec zsh
```

## Post-Installation Configuration

### Local Configuration Files

**~/.gitconfig-local**

```bash
cat > ~/.gitconfig-local << 'EOF'
[user]
    email = your.email@company.com
    name = Your Name
    signingkey = YOUR_GPG_KEY_ID

[commit]
    gpgsign = true
EOF
```

**~/.zshrc_local**

Machine-specific shell overrides:

```bash
touch ~/.zshrc_local
# Add PATH modifications, corporate proxy, etc.
```

**~/.local/bin/env**

Environment variables:

```bash
mkdir -p ~/.local/bin
cat > ~/.local/bin/env << 'EOF'
# Machine-specific environment variables
EOF
```

### Configure Spotlight

Index ~/Applications for Spotlight search:

```bash
mdutil -i on ~/Applications
mdutil -E ~/Applications  # Rebuild if needed
```

Test with Cmd+Space.

### Verify Doom Emacs

```bash
~/.emacs.d/bin/doom doctor
~/.emacs.d/bin/doom sync
```

Fix any reported issues.

## Corporate-Specific Setup

Install corporate-required tool versions using SDKMAN!:

```bash
source ~/.sdkman/bin/sdkman-init.sh

# List available versions
sdk list java
sdk list maven
sdk list gradle

# Install required versions
sdk install java VERSION
sdk install maven VERSION
sdk install gradle VERSION

# Set defaults
sdk default java VERSION
sdk default maven VERSION

# Verify
java -version
mvn -version
```

## Data Migration

### SSH Keys

Transfer from old computer and set permissions:

```bash
# Copy keys from backup
cp ~/backup/ssh/* ~/.ssh/

# Set permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*
chmod 644 ~/.ssh/*.pub
chmod 600 ~/.ssh/config

# Test
ssh -T git@github.com
```

### GPG Keys

Import keys from backup:

```bash
gpg --import ~/backup/gpg-private.asc
gpg --import ~/backup/gpg-public.asc
gpg --import-ownertrust ~/backup/gpg-ownertrust.txt

# Verify
gpg --list-secret-keys

# Set trust
gpg --edit-key YOUR_KEY_ID
# trust → 5 (ultimate) → quit
```

### Knowledge Base

Transfer org files:

```bash
# From old computer (via rsync, Time Machine, or manual copy)
rsync -avz OLD_COMPUTER:~/org/ ~/org/
rsync -avz OLD_COMPUTER:~/org/roam/ ~/org/roam/
```

### Version Manager State

Use migration helper scripts:

```bash
# Restore Volta Node.js versions
./scripts/install-versions.sh ~/migration-volta-*.txt

# Restore uv Python versions
./scripts/install-versions.sh ~/migration-uv-*.txt

# SDKMAN! requires manual installation (see above)
```

### IDE Settings

**JetBrains**

- Open IntelliJ IDEA via JetBrains Toolbox
- Sign in and enable Settings Sync
- Wait for sync

**VS Code**

- Open VS Code
- Sign in and enable Settings Sync

**Browser**

Import bookmarks from exported file.

### Application Data Restoration

**Setapp Apps**

After installing Setapp:

1. Sign in to Setapp
2. Reinstall apps from your old machine list
3. Restore backed-up data for key apps:
   - BetterTouchTool: Import presets from backup
   - Timing: Restore `~/Library/Application Support/info.eurocomp.Timing2/`
   - Dash: Restore docsets from backup
   - ForkLift: Restore favorites/bookmarks
   - LaunchBar: Restore actions and abbreviations

**Productivity Tools**

- **Raycast/Alfred**: Sign in to sync extensions and snippets
- **Contexts**: Import preferences from backup
- **Karabiner-Elements**: Configuration should be in dotfiles

**Knowledge Management**

If you use Logseq, Craft, or similar:

- Restore graph/vault directories from backup
- Verify cloud sync is complete
- Test opening and editing notes

## Verification

Test development environment:

```bash
# Version managers
java -version
mvn -version
node -version
python3 --version

# Git operations
git clone git@github.com:your-org/test-repo.git

# GPG signing
cd test-repo
git commit --allow-empty -S -m "test"

# Tools
kubectl version --client
psql --version
mysql --version

# Homebrew
brew doctor
```

### Build a Project

Final verification:

```bash
cd ~/developer/COMPANY/YOUR_PROJECT
./gradlew build
# or
mvn clean install
```

## Troubleshooting

### Homebrew Not Found

```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

### Apps Not in ~/Applications

```bash
echo $HOMEBREW_CASK_OPTS  # Should show --appdir=...
brew reinstall --cask APPNAME
```

### Doom Emacs Errors

```bash
~/.emacs.d/bin/doom doctor
~/.emacs.d/bin/doom sync
~/.emacs.d/bin/doom build
```

### SDKMAN! Not Found

```bash
source ~/.sdkman/bin/sdkman-init.sh
exec zsh
```

### Git Signing Fails

```bash
echo "test" | gpg --clearsign
gpgconf --kill gpg-agent
gpgconf --launch gpg-agent
git config --global gpg.program $(which gpg)
```

### SSH Keys Not Working

```bash
ssh-add ~/.ssh/id_ed25519
ssh-add ~/.ssh/id_rsa
ssh -T git@github.com
```

## Maintenance

Keep system updated:

```bash
# Update everything
topgrade

# Or individually
brew update && brew upgrade
sdk update && sdk upgrade
volta install node@lts
rustup update
doom upgrade
```

Review and update install.conf.yaml as needs change.
