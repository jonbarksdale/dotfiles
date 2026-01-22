-- ABOUTME: Neovim init file for LazyVim-based configuration
-- ABOUTME: Sets plugin variables before lazy.nvim loads, then bootstraps LazyVim

-- vim-table-mode settings (must be set before plugin loads)
-- These use VimL via vim.cmd because the VimL plugin checks with exists()
vim.cmd([[
  let g:table_mode_corner = '|'
  let g:table_mode_map_prefix = '<leader>m'
  let g:table_mode_realign_map = '<leader>mr'
  let g:table_mode_delete_row_map = '<leader>mdd'
  let g:table_mode_delete_column_map = '<leader>mdc'
  let g:table_mode_insert_column_before_map = '<leader>miC'
  let g:table_mode_insert_column_after_map = '<leader>mic'
  let g:table_mode_add_formula_map = '<leader>mfa'
  let g:table_mode_eval_formula_map = '<leader>mfe'
  let g:table_mode_echo_cell_map = '<leader>m?'
  let g:table_mode_sort_map = '<leader>ms'
  let g:table_mode_tableize_map = '<leader>mt'
  let g:table_mode_tableize_d_map = '<leader>mT'
  let g:table_mode_cell_text_object_i_map = 'ic'
  let g:table_mode_cell_text_object_a_map = 'ac'
  let g:table_mode_auto_align = 1
  " Note: always_active = 0 so toggle command exists and creates buffer mappings
  let g:table_mode_always_active = 0
]])

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
