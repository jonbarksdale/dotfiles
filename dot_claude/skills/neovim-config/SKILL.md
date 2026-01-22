# ABOUTME: Neovim configuration skill for LazyVim-based dotfiles setup
# ABOUTME: Auto-triggers when working with nvim config, ensures plugin verification

---
name: neovim-config
description: Neovim plugin installation and configuration for LazyVim-based setup. Auto-triggers when working in nvim config directories.
triggers:
  - path: "**/dot_config/nvim/**"
  - path: "**/.config/nvim/**"
  - keywords: ["neovim", "nvim", "lazyvim", "nvim plugin"]
---

# Neovim Configuration Skill

Configuration standards for LazyVim-based neovim setup managed via chezmoi.

# PLUGIN INSTALLATION CHECKLIST

When adding a new neovim plugin, complete these steps in order:

## 1. Verify Plugin Exists

**BEFORE writing any config**, verify the GitHub repo exists:

```bash
# Use WebFetch to check the repo
WebFetch: https://github.com/{owner}/{repo}
```

If the repo doesn't exist or is archived, find an alternative.

## 2. Check Keymap Conflicts

Before adding keybindings, check for conflicts:

```bash
# Check specific prefix
nvim --headless -c "redir! > /tmp/maps.txt | silent verbose map <leader>X | redir END" -c "qa"
cat /tmp/maps.txt

# Common prefixes already in use:
# <leader>t  - Neotest (testing)
# <leader>m  - Mode-specific (filetype bindings) - USE THIS
# <leader>c  - Code actions
# <leader>f  - Find/files
# <leader>g  - Git
# <leader>s  - Search
# <leader>o  - Obsidian
```

## 3. Follow LazyVim Plugin Spec

Use this structure for plugin files:

```lua
-- ABOUTME: Brief description of what plugin does
-- ABOUTME: Key bindings and features summary

return {
  "owner/repo-name",
  ft = { "filetype" },  -- Lazy load by filetype when possible
  dependencies = {},     -- List dependencies if any
  init = function()
    -- Settings that must be set BEFORE plugin loads
    vim.g.plugin_setting = "value"
  end,
  opts = {
    -- Settings passed to plugin's setup() function
  },
  config = function()
    -- Complex setup logic, autocmds, etc.
  end,
  keys = {
    -- Keybindings with ft= for filetype-specific
    { "<leader>mx", "<cmd>Command<cr>", desc = "Description", ft = "filetype" },
  },
}
```

## 4. Use `<leader>m` for File-Type Bindings

File-type-specific bindings use `<leader>m` prefix with `ft=` to restrict scope:

```lua
-- Good: <leader>m with ft= restriction
{ "<leader>mtf", "<cmd>TableFormat<cr>", desc = "Format table", ft = "markdown" }

-- Bad: global binding without ft=
{ "<leader>tf", "<cmd>TableFormat<cr>", desc = "Format table" }
```

This follows LazyVim's pattern (Scala extras use `<leader>me`, `<leader>mc`, etc.)

## 5. Create Test File

For plugins with interactive features, create a test file appropriate to the plugin:

```bash
# Choose file type based on plugin's target
/tmp/test-{plugin}.{ext}  # Use appropriate extension for the filetype
```

Test file requirements:
- **Correct filetype**: Match the plugin's `ft` setting (e.g., `.py` for Python plugins, `.md` for markdown)
- **Sample content**: Include realistic content the plugin operates on
- **Numbered test steps**: Clear instructions for each feature to verify
- **Expected behavior**: What should happen for each test
- **Results checklist**: Checkboxes for user to report pass/fail

Examples by plugin type:
- Table plugin → markdown file with sample tables
- LSP plugin → source file with errors/warnings to detect
- Git plugin → file in a git repo with uncommitted changes
- Formatter → file with intentionally poor formatting

## 6. Apply and Verify

```bash
# Apply via chezmoi
chezmoi apply --force ~/.config/nvim/lua/plugins/{plugin}.lua

# Verify file deployed
ls -la ~/.config/nvim/lua/plugins/{plugin}.lua

# Open nvim with test file - lazy.nvim will auto-install
nvim /tmp/test-{plugin}.{ext}
```

# CONFIGURATION LOCATIONS

| Purpose | Path |
|---------|------|
| Plugin specs | `dot_config/nvim/lua/plugins/*.lua` |
| Keymaps | `dot_config/nvim/lua/config/keymaps.lua` |
| Autocmds | `dot_config/nvim/lua/config/autocmds.lua` |
| Options | `dot_config/nvim/lua/config/options.lua` |
| Lazy setup | `dot_config/nvim/lua/config/lazy.lua` |

# KEYBINDING CONVENTIONS

## Prefixes

| Prefix | Purpose | Owner |
|--------|---------|-------|
| `<leader>` (Space) | Global commands | LazyVim + custom |
| `<leader>m` | Mode/filetype-specific | Per-filetype plugins |
| `g` | Go-to commands | Built-in + LSP |
| `]` / `[` | Next/prev navigation | Built-in + plugins |

## Mode-Specific Namespaces (`<leader>m`)

| Filetype | Prefix | Purpose |
|----------|--------|---------|
| markdown | `<leader>mt` | Table operations |
| scala/sbt | `<leader>me/mc/mh` | Metals LSP |

When adding new filetype bindings, choose a unique second letter to avoid conflicts.

# COMMON ISSUES

## Plugin Not Loading

1. Check `:Lazy` for errors
2. Verify `ft` matches actual filetype (`:set ft?`)
3. Check if keybindings trigger load

## Keymap Conflicts

1. Use `:verbose map <key>` to find source
2. Check LazyVim defaults: https://www.lazyvim.org/keymaps
3. Override in plugin spec or keymaps.lua

## Bindings Appear Globally

If filetype bindings show up everywhere:
1. Add `ft = { "filetype" }` to key definitions
2. Create override file in `lua/plugins/` to fix LazyVim extras

## Chezmoi Not Applying

1. File must be in source dir (`dot_config/nvim/...`)
2. Run `chezmoi diff` to preview
3. Use `chezmoi apply --force` to deploy

## VimL Plugin Variables Not Working

The `init` function is the correct place for `vim.g.*` variables - it runs at startup before plugin load. If variables still aren't being picked up:

1. **Verify you're using `init`, not `config`**:
   ```lua
   {
     "plugin/name",
     init = function()
       vim.g.plugin_variable = "value"  -- Runs BEFORE plugin loads
     end,
     config = function()
       -- Runs AFTER plugin loads - too late for vim.g
     end,
   }
   ```

2. **Check if plugin creates mappings on-demand vs. at load**:
   - Some VimL plugins create mappings only when a mode is enabled (e.g., vim-table-mode creates buffer-local mappings only when `:TableModeEnable` is called)
   - Use `:filter /pattern/ map` to see what mappings actually exist
   - Solution: Add autocmd to enable the mode for specific filetypes

3. **Clear lazy.nvim cache** when debugging:
   ```bash
   rm -rf ~/.local/state/nvim/lazy ~/.local/share/nvim/lazy/plugin-name
   ```

# CRITICAL RULES

- **ALWAYS verify plugin repo exists** before writing config
- **ALWAYS check keymap conflicts** before adding bindings
- **ALWAYS use ABOUTME comments** in plugin files
- **ALWAYS use `ft=` with `<leader>m` bindings** to restrict to filetype
- **NEVER use `<leader>t`** - reserved for Neotest
- **PREFER `<leader>m`** for file-type-specific bindings
- **PREFER `ft = {...}`** for lazy loading by filetype
- **CREATE test files** for interactive plugins
