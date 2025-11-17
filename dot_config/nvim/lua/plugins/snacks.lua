-- ABOUTME: Snacks.nvim configuration with Copilot toggle functionality
-- ABOUTME: Provides a pretty toggle UI for enabling/disabling GitHub Copilot completion

return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>at",
      function()
        local ok, copilot_command = pcall(require, "copilot.command")
        if not ok then
          vim.notify("Copilot not available", vim.log.levels.WARN)
          return
        end

        local toggle = Snacks.toggle({
          name = "Copilot",
          get = function()
            return vim.g.copilot_enabled ~= false
          end,
          set = function(enabled)
            if enabled then
              copilot_command.enable()
              vim.g.copilot_enabled = true
            else
              copilot_command.disable()
              vim.g.copilot_enabled = false
            end
          end,
        })
        toggle:toggle()
      end,
      desc = "Toggle Copilot",
    },
  },
}

