-- ABOUTME: Markdown table editing with auto-formatting and cell text objects
-- ABOUTME: Settings are in init.lua; this enables table mode for markdown files

return {
  "dhruvasagar/vim-table-mode",
  ft = { "markdown" },
  cmd = { "TableModeToggle", "TableModeEnable", "Tableize" },
  config = function()
    -- Auto-enable table mode for markdown files
    -- This triggers ToggleMapping() which creates all the buffer-local keybindings
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function()
        -- Defer to ensure plugin is fully loaded
        vim.defer_fn(function()
          vim.cmd("silent! TableModeEnable")
        end, 10)
      end,
    })
  end,
}
