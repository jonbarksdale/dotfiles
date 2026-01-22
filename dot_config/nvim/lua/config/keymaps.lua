-- ABOUTME: Custom keymaps extending LazyVim defaults
-- ABOUTME: Establishes <leader>m as mode-specific prefix (like Doom Emacs)

-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
--
-- Keymap conventions:
--   <leader>m  - Mode/filetype-specific commands (markdown tables, LSP actions, etc.)
--   <leader>M  - Metals (Scala LSP) - moved from <leader>m
--
-- File-type plugins should define <leader>m* bindings via autocmds or ft= in lazy.nvim

local map = vim.keymap.set

map("n", "<leader>fs", "<cmd>w<cr>", { desc = "Save file" })
