# Pre-Migration Checklist

ABOUTME: Checklist of data and configuration to back up before migrating to a
ABOUTME: new computer.

## Quick Checklist

- [ ] Export version manager state (run `./scripts/export-versions.sh`)
- [ ] Back up local config files (~/.gitconfig-local, ~/.zshrc_local, etc.)
- [ ] Verify org files backed up (~/org, ~/org/roam)
- [ ] Export SSH keys securely
- [ ] Export GPG keys securely
- [ ] Verify 1Password/password manager sync
- [ ] Enable IDE settings sync (JetBrains, VS Code)
- [ ] Export browser bookmarks
- [ ] Back up application data (see Application Data Migration section)
- [ ] Note Setapp subscription and installed apps
- [ ] Save any uncommitted work in repositories
- [ ] Document active projects and locations

## Version Manager State

### Automated Export

Run the export script to capture all version manager state:

```bash
./scripts/export-versions.sh
```

Creates timestamped files with SDKMAN!, Volta, uv, Homebrew, and git state.

### Corporate-Specific Versions

If you use corporate-required versions, document them separately:

- Java versions and distributions
- Maven version
- Gradle version (if not using wrapper)
- Node.js versions and global packages
- Python versions and tools

## Local Configuration Files

Back up these machine-specific files:

- `~/.gitconfig-local` - Git config (email, signing keys, corporate settings)
- `~/.zshrc_local` - Shell configuration overrides
- `~/.zshrc_before` - Pre-configuration hooks
- `~/.profile` - PATH modifications
- `~/.local/bin/env` - Environment variables
- `~/.ssh/config` - SSH configuration
- `~/.aws/config` and `~/.aws/credentials` - AWS configuration

## Knowledge Base

Ensure backups of:

- `~/org/` - Org-mode files
- `~/org/roam/` - Org-roam knowledge base

Verify recent backup:

```bash
du -sh ~/org ~/org/roam
```

## SSH and GPG Keys

### SSH Keys

List and back up securely:

```bash
ls -la ~/.ssh/
ssh-add -l  # Currently loaded keys
```

Export private keys to encrypted storage (password manager, encrypted drive).

### GPG Keys

List and export:

```bash
gpg --list-secret-keys --keyid-format LONG
gpg --export-secret-keys YOUR_KEY_ID > gpg-private-backup.asc
gpg --export YOUR_KEY_ID > gpg-public-backup.asc
gpg --export-ownertrust > gpg-ownertrust.txt
```

Store exports securely and encrypted.

## Application Data Migration

### Enable Settings Sync

- **1Password**: Verify sync to other devices
- **JetBrains IDEs**: Settings → IDE Settings Sync
- **VS Code**: Settings → Settings Sync
- **Browser**: Export bookmarks as backup

### Setapp Subscription

- **Note**: Setapp apps will need to be reinstalled on new computer
- **Action**: Sign in to Setapp on new machine and reinstall needed apps
- **Current Setapp apps to reinstall**:
  - BetterTouchTool (gestures and automation)
  - Bartender (menu bar management)
  - CleanShot X (screenshot tool)
  - Dash (documentation browser)
  - Default Folder X (file dialog enhancement)
  - ForkLift (FTP/file manager)
  - iStat Menus (system monitoring)
  - Proxyman (HTTP debugging)
  - Timing (time tracking)
  - And others based on your usage

**Setapp data to back up**:

- BetterTouchTool configurations: `~/Library/Application Support/BetterTouchTool/`
- Timing data: `~/Library/Application Support/info.eurocomp.Timing2/`
- Dash docsets: `~/Library/Application Support/Dash/`

### Application-Specific Data

**Development Tools**:

- **JetBrains IDEs**: Plugins, keymaps, code styles (enable Settings Sync)
  - Live templates location: `~/Library/Application Support/JetBrains/`
- **VS Code**: Extensions, settings (enable Settings Sync)
- **Cursor/Zed**: Settings and extensions if applicable

**Knowledge Management**:

- **Logseq**: `~/Documents/Logseq/` or graph location
- **Craft**: Cloud-synced, verify sync complete
- **Obsidian**: If using, note vault locations

**Productivity**:

- **Raycast**: Extensions, snippets, hotkeys (check cloud sync)
- **Alfred**: Workflows, snippets (check cloud sync or export)
- **LaunchBar**: Actions and abbreviations
  - Config: `~/Library/Application Support/LaunchBar/`
- **Contexts**: Sidebar layout and shortcuts
  - Config: `~/Library/Preferences/com.contexts.Contexts.plist`

**Communication**:

- **Slack**: Workspaces auto-sync, but note which workspaces
- **Zoom**: Sign in again on new machine
- **Grammarly**: Sign in again on new machine

**Browsers**:

- **Arc**: Spaces and settings (cloud sync, verify)
- **Chrome**: Bookmarks, extensions (sign in to sync)
- **Orion/Vivaldi**: Export bookmarks and settings

**Design/Creative**:

- **Figma**: Cloud-based, just sign in
- **CleanShot X**: Capture history if needed
  - Captures: `~/Library/Application Support/CleanShot/`

**File Management**:

- **DaisyDisk**: Scan results (not critical)
- **ForkLift**: Bookmarks and favorites
  - Config: `~/Library/Application Support/ForkLift/`

**Window Management**:

- **AeroSpace**: Configuration already in dotfiles if tracked
- **Contexts**: Export preferences
- **Magnet/Swish**: Preferences (may need manual export)

**Note-Taking**:

- **Antinote/Slipbox**: Database and notes
- **GoodNotes**: iCloud sync, verify complete
- **Logseq**: Graph directories

**System Utilities**:

- **Bartender**: Menu bar layout
- **Karabiner-Elements**: Configuration (check `~/.config/karabiner/`)
- **BetterTouchTool**: Gestures and shortcuts (export from app)
- **iStat Menus**: Preferences

### Data Location Quick Reference

Common application data locations to check:

```bash
~/Library/Application Support/  # Most app data
~/Library/Preferences/           # App preferences/plists
~/Documents/                     # User documents
~/Downloads/                     # Temporary downloads
```

List all application support folders:

```bash
ls -la ~/Library/Application\ Support/ | grep -v "^d.*\.$"
```

## Optional: Shell History

```bash
cp ~/.histfile ~/histfile-backup-$(date +%Y%m%d).txt
```
