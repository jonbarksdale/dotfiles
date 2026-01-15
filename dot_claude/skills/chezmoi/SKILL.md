# ABOUTME: Chezmoi dotfiles management skill for cross-machine configuration
# ABOUTME: Auto-triggers when working in dotfiles repos or chezmoi source directory

---
name: chezmoi
description: Dotfiles management with chezmoi. Auto-triggers when working in dotfiles repos or chezmoi source directory.
triggers:
  - path: "**/dotfiles/**"
  - path: "**/.local/share/chezmoi/**"
  - keywords: ["dotfiles", "chezmoi", ".zshrc", ".vimrc", ".config"]
---

# Chezmoi Dotfiles Management

Manage dotfiles with chezmoi for cross-machine configuration synchronization.

# CORE COMMANDS

## Status & Inspection
- `chezmoi status` — Quick overview of what differs between source and target
- `chezmoi diff` — Detailed diff of pending changes
- `chezmoi managed` — List all files under chezmoi management
- `chezmoi data` — Show available template variables
- `chezmoi doctor` — Diagnose configuration issues

## Applying Changes
- `chezmoi apply --refresh-externals --force` — Deploy changes (flags required)
  - `--refresh-externals`: Update external dependencies
  - `--force`: Prevent interactive prompts that block automation

## Editing & Previewing
- `chezmoi edit <file>` — Open source file in editor
- `chezmoi cat <file>` — Preview rendered template output (ALWAYS preview before apply)
- `chezmoi execute-template` — Test template syntax interactively

## Adding Files
- `chezmoi add <file>` — Add file to chezmoi management
- `chezmoi add --template <file>` — Add as template for machine-specific config

# FILE NAMING CONVENTIONS

| Prefix/Suffix | Effect | Example |
|---------------|--------|---------|
| `dot_` | Adds leading dot | `dot_zshrc` → `~/.zshrc` |
| `private_` | Sets 600 permissions | `private_dot_ssh/` |
| `executable_` | Sets 755 permissions | `executable_dot_profile` |
| `readonly_` | Sets 444 permissions | `readonly_config` |
| `symlink_` | Creates symbolic link | `symlink_dot_vim` |
| `empty_` | Ensures empty file exists | `empty_dot_placeholder` |
| `exact_` | Removes extraneous files in directory | `exact_dot_config/` |
| `.tmpl` | Process as Go template | `dot_zshrc.tmpl` |

Prefixes combine: `private_executable_dot_script.tmpl`

Order: `<type>_<permissions>_<name>.<suffix>`

# TEMPLATING

## Available Data
Run `chezmoi data` to see available variables. Common ones:
- `{{ .chezmoi.os }}` — "darwin", "linux", etc.
- `{{ .chezmoi.hostname }}` — machine hostname
- `{{ .chezmoi.username }}` — current user

## Conditionals
```go-template
{{- if eq .chezmoi.os "darwin" }}
# macOS only
brew install something
{{- else if eq .chezmoi.os "linux" }}
# Linux only
apt install something
{{- end }}

{{- if and (eq .chezmoi.os "darwin") (env "WORK_ENV") }}
# macOS work machine only
{{- end }}
```

## Template Escaping
When target files use `{{ }}` syntax (mise, Jinja2):
```go-template
{{ "{{" }} variable {{ "}}" }}
```
Renders as: `{{ variable }}`

## Testing Templates
```bash
chezmoi execute-template '{{ .chezmoi.os }}'
chezmoi cat ~/.zshrc  # Preview rendered output before apply
```

# SCRIPTS

Place scripts in `.chezmoiscripts/`.

## Script Types

| Prefix | When It Runs | Use Case |
|--------|--------------|----------|
| `run_once_` | First apply only | Install Homebrew, Rust, one-time setup |
| `run_onchange_` | When script content changes | `brew bundle`, mise setup |
| `run_after_` | Every apply, after files | Doom Emacs sync |

## Ordering

Add numeric prefix for execution order:
- `run_once_before_10-install-homebrew.sh.tmpl`
- `run_onchange_before_20-brew-bundle.sh.tmpl`
- `run_once_before_30-install-rust.sh.tmpl`

Lower numbers run first. `before_` runs before file changes, `after_` runs after.

## Template Scripts

Add `.tmpl` suffix for OS-conditional scripts:
```bash
#!/bin/bash
{{- if eq .chezmoi.os "darwin" }}
brew bundle --file={{ .chezmoi.sourceDir }}/dot_Brewfile
{{- end }}
```

# FILE MANAGEMENT

## Ignoring Files (.chezmoiignore)

Files in source that should NOT be deployed to home directory:
```
README.md
LICENSE
docs/
.chezmoiscripts/
scripts/
```

## Removing Files (.chezmoiremove)

When you rename or delete files in chezmoi source, the old files remain in home. Use `.chezmoiremove` to clean them up:
```
# Old skill names after renaming
.claude/skills/old-name

# Deleted config directories
.config/deprecated-tool/
```

For conditional removal, use `.chezmoiremove.tmpl`:
```go-template
{{- if eq .chezmoi.os "darwin" }}
# Only remove on macOS
.config/linux-only-tool/
{{- end }}
```

Preview removals with `chezmoi diff` before applying.

## External Dependencies (.chezmoiexternal.toml)

Manage external git repos:
```toml
[".vim/pack/plugins/start/vim-surround"]
    type = "git-repo"
    url = "https://github.com/tpope/vim-surround.git"
    refreshPeriod = "168h"
```

# WORKFLOW

## Making Changes

1. **Edit source, not target**: Use `chezmoi edit <file>` or edit directly in source repo
2. **Preview before apply**: Run `chezmoi cat <file>` for templates, `chezmoi diff` for all changes
3. **Apply with required flags**: `chezmoi apply --refresh-externals --force`
4. **Commit changes**: Commit to source repo after verifying

## Adding New Files

```bash
chezmoi add ~/.newconfig
chezmoi add --template ~/.newconfig  # For machine-specific content
```

## Troubleshooting

```bash
chezmoi doctor
chezmoi status
chezmoi diff
chezmoi data
chezmoi execute-template '{{ .chezmoi.os }}'
```

## Critical Rules

- **NEVER edit target files directly** — Changes overwritten on next apply
- **ALWAYS preview templates** with `chezmoi cat` before applying
- **Use --force flag** to prevent interactive prompts blocking automation
- **Use .chezmoiremove** for cleanup, never manually delete managed files

See [reference.md](./reference.md) for additional details.
