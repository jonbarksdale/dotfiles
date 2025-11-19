# Work Dotfiles Integration

This document explains how to integrate work-specific configuration with the personal dotfiles managed by chezmoi.

## Architecture

The dotfiles use a **two-repository pattern**:

1. **Personal dotfiles** (this repo): `~/.local/share/chezmoi/`
   - Managed by chezmoi
   - Contains shared configuration for all machines
   - Public repository (or private if you prefer)

2. **Work dotfiles** (separate repo): Location of your choice
   - Optional work-specific repository
   - Contains work-only configuration
   - Not managed by chezmoi - uses own setup script
   - Should NOT be in a public repository

## Integration Points

Work configuration integrates through runtime file sourcing. The personal dotfiles source optional override files that the work repo provides:

### Shell Configuration

| File | Sourced When | Purpose |
|------|-------------|---------|
| `~/.zshrc_before` | At start of zshrc | Work environment setup, early PATH additions |
| `~/.profile.local` | From ~/.profile | Work-specific PATH and environment variables |
| `~/.zshrc_local` | At end of zshrc | Work shell aliases, functions, prompt customization |

### Git Configuration

| File | Included When | Purpose |
|------|--------------|---------|
| `~/.gitconfig-local` | From ~/.config/git/config | Work email, signing key, work-specific aliases |

The git include happens **last**, so work settings override personal settings.

## Work Repo Structure

Recommended structure for your work dotfiles repository:

```
dotfiles-work/              # Clone wherever you prefer
├── README.md
├── setup.sh                # Creates symlinks to home directory
├── dot_zshrc_before       # Work environment setup
├── dot_profile.local      # Work PATH additions
├── dot_zshrc_local        # Work shell customization
└── dot_gitconfig-local    # Work git configuration
```

### Example setup.sh

```bash
#!/bin/bash
# Setup script for work dotfiles

# Get the directory where this script is located
WORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create symlinks
ln -sf "$WORK_DIR/dot_zshrc_before" "$HOME/.zshrc_before"
ln -sf "$WORK_DIR/dot_profile.local" "$HOME/.profile.local"
ln -sf "$WORK_DIR/dot_zshrc_local" "$HOME/.zshrc_local"
ln -sf "$WORK_DIR/dot_gitconfig-local" "$HOME/.gitconfig-local"

echo "Work dotfiles linked successfully from $WORK_DIR"
```

## Example Work Configuration Files

### ~/.profile.local (Work PATH)

See `docs/examples/profile.local.example` for a template with common work configurations.

Example work-specific items:

```bash
#!/bin/sh
# Work-specific PATH and environment variables

# Work certificates
export AWS_CA_BUNDLE="$HOME/certs/work-ca-bundle.crt"

# Corp VPN tools
export PATH="/opt/corpo/bin:$PATH"

# Java version for work projects
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk-11.jdk/Contents/Home"

# Work-specific environment
export CORPO_ENV="development"

# Conda/Anaconda for work projects
if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
    . "$HOME/miniconda3/etc/profile.d/conda.sh"
fi
```

### ~/.gitconfig-local (Work Git Config)

```ini
[user]
    email = jbarksdale@corpo.com
    signingkey = WORK_GPG_KEY_ID

[commit]
    gpgsign = true

[url "git@github.corpo.com:"]
    insteadOf = https://github.corpo.com/
```

### ~/.zshrc_local (Work Shell Customization)

```bash
# Work-specific aliases
alias vpn='sudo openconnect vpn.corpo.com'
alias prod='ssh production-server.corpo.com'

# Work-specific prompt customization
export STARSHIP_CONFIG="$HOME/.config/starship-work.toml"

# Load work secrets from 1Password
export CORPO_API_KEY="$(op read 'op://Work/corpo API/credential')"
```

## Setup Process

### On a Work Machine

1. Apply personal dotfiles:

   ```bash
   chezmoi init --apply https://github.com/yourusername/dotfiles.git
   ```

2. When prompted "Is this a work machine ?", answer **yes**
   - This sets the `{{ .work }}` variable to `true`
   - Currently not used but available for future templating

3. Clone work dotfiles (to any location you prefer):

   ```bash
   git clone <your-work-repo-url> ~/path/to/dotfiles-work
   ```

4. Run work setup:

   ```bash
   cd ~/path/to/dotfiles-work
   ./setup.sh
   ```

5. Restart shell to load all configuration

### On a Personal Machine

1. Apply personal dotfiles:

   ```bash
   chezmoi init --apply https://github.com/yourusername/dotfiles.git
   ```

2. When prompted "Is this a work machine ?", answer **no**

3. Done! Personal config only, no work overrides

## Benefits of This Approach

1. **Complete separation** - Work config stays in work repo, never accidentally pushed to personal repo
2. **Clean personal config** - Personal dotfiles work standalone without work-specific cruft
3. **Flexible** - Can mix and match which work overrides you want
4. **Standard pattern** - Uses common shell sourcing patterns, no chezmoi magic required
5. **Easy to disable** - Remove symlinks to disable work config temporarily

## Chezmoi Work Variable

The `.chezmoi.yaml.tmpl` file defines a `{{ .work }}` variable that can be used in templates:

```yaml
data:
  work: {{ $work }}  # true or false based on prompt
```

This variable is currently **not used** but is available for future conditional configuration in chezmoi-managed files. For example:

```bash
# In a .tmpl file
{{- if .work }}
export WORK_MODE=true
{{- end }}
```

For now, the two-repository pattern is preferred over templating work config into the personal repo.
