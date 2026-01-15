# ABOUTME: Extended reference for chezmoi dotfiles management
# ABOUTME: Contains advanced patterns, full command reference, and troubleshooting

# Chezmoi Reference

## Full Command Reference

### Initialization
```bash
chezmoi init <repo-url>           # Initialize from git repo
chezmoi init --apply <repo-url>   # Initialize and apply immediately
```

### Daily Operations
```bash
chezmoi add <file>                # Add file to management
chezmoi add --template <file>     # Add as template
chezmoi edit <file>               # Edit source file
chezmoi apply                     # Apply changes (prefer with flags below)
chezmoi apply --refresh-externals --force  # Full apply with externals
chezmoi update                    # Pull and apply (git pull + apply)
```

### Inspection
```bash
chezmoi status                    # Show what differs (quick)
chezmoi diff                      # Show detailed diff
chezmoi managed                   # List managed files
chezmoi unmanaged                 # List files in ~ not managed
chezmoi cat <file>                # Show rendered template
chezmoi data                      # Show template data
chezmoi source-path <file>        # Show source path for target
chezmoi target-path <file>        # Show target path for source
```

### Troubleshooting
```bash
chezmoi doctor                    # Run diagnostics
chezmoi execute-template <string> # Test template rendering
chezmoi verify                    # Verify target state matches source
chezmoi state dump                # Show chezmoi state database
```

### Git Operations
```bash
chezmoi cd                        # Open shell in source directory
chezmoi git <args>                # Run git in source directory
chezmoi git status                # Example: git status in source
```

## Advanced Template Functions

### String Functions
```go-template
{{ .chezmoi.hostname | lower }}           # Lowercase
{{ .chezmoi.hostname | upper }}           # Uppercase
{{ trimSuffix ".local" .chezmoi.hostname }}  # Remove suffix
{{ hasPrefix "work-" .chezmoi.hostname }} # Check prefix (returns bool)
```

### Environment Variables
```go-template
{{ env "HOME" }}                  # Get environment variable
{{ env "WORK_ENV" | default "" }} # With default
```

### File Operations
```go-template
{{ include "path/to/file" }}      # Include file contents
{{ .chezmoi.sourceDir }}          # Path to source directory
```

### Conditional Patterns
```go-template
{{- if and (eq .chezmoi.os "darwin") (hasPrefix "work-" .chezmoi.hostname) }}
# macOS work machine only
{{- end }}

{{- if or (eq .chezmoi.os "darwin") (eq .chezmoi.os "linux") }}
# Unix-like systems
{{- end }}
```

## Script Execution Details

### Script Naming Pattern
```
run_[once|onchange|always]_[before|after]_<order>-<name>.sh[.tmpl]
```

### Execution Order
1. `run_*_before_*` scripts (by numeric order)
2. File changes applied
3. `run_*_after_*` scripts (by numeric order)

### Script State
- `run_once_` state stored in `~/.local/share/chezmoi`
- Clear with: `chezmoi state delete-bucket --bucket=scriptState`
- Re-run all once scripts: delete state, then apply

### Onchange Detection
`run_onchange_` scripts track content hash. To force re-run:
- Add a comment with version/date
- Change any content in the script

## External Dependencies

### Git Repositories
```toml
[".vim/pack/plugins/start/vim-surround"]
    type = "git-repo"
    url = "https://github.com/tpope/vim-surround.git"
    refreshPeriod = "168h"
    [".vim/pack/plugins/start/vim-surround".pull]
        args = ["--ff-only"]
```

### Archives
```toml
[".local/bin/tool"]
    type = "archive"
    url = "https://example.com/tool-v1.0.tar.gz"
    stripComponents = 1
    refreshPeriod = "720h"
```

### Files
```toml
[".local/bin/script"]
    type = "file"
    url = "https://example.com/script.sh"
    executable = true
    refreshPeriod = "168h"
```

## Common Patterns

### OS-Specific Files
Use templates or separate files:
```
dot_config/
  tool/
    config.toml.tmpl        # Templated for OS differences
    config_darwin.toml      # macOS-specific (manually sourced)
    config_linux.toml       # Linux-specific (manually sourced)
```

### Private Files
```
private_dot_ssh/
  private_config           # ~/.ssh/config with 600 permissions
  private_id_rsa           # Private key
```

### Exact Directories
Remove files not in source:
```
exact_dot_config/
  exact_tool/              # Only files in source exist in target
```

## Debugging

### Verbose Apply
```bash
chezmoi apply --verbose --dry-run  # Show what would happen
chezmoi apply --debug              # Very verbose output
```

### Template Debugging
```bash
# Test specific template expression
chezmoi execute-template '{{ .chezmoi | toJson }}'

# Check what a file will render to
chezmoi cat ~/.zshrc

# Compare rendered vs current
chezmoi diff ~/.zshrc
```

### State Issues
```bash
chezmoi state dump                    # View state database
chezmoi state delete-bucket --bucket=scriptState  # Reset script state
chezmoi forget <file>                 # Remove file from management
```
