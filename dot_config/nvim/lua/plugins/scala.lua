-- ABOUTME: Scala/Metals LSP configuration override
-- ABOUTME: Disables global <leader>m bindings, adds buffer-local ones for scala files

return {
  -- Disable the global keybindings from LazyVim's scala extra
  {
    "scalameta/nvim-metals",
    keys = {
      -- Disable each default binding by setting to false
      { "<leader>me", false },
      { "<leader>mc", false },
      { "<leader>mh", false },
    },
  },

  -- Add buffer-local keybindings for scala files only
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt", "java" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "scala", "sbt", "java" },
        callback = function()
          local map = vim.keymap.set
          map("n", "<leader>me", function()
            require("telescope").extensions.metals.commands()
          end, { buffer = true, desc = "Metals commands" })
          map("n", "<leader>mc", function()
            require("metals").compile_cascade()
          end, { buffer = true, desc = "Metals compile cascade" })
          map("n", "<leader>mh", function()
            require("metals").hover_worksheet()
          end, { buffer = true, desc = "Metals hover worksheet" })
        end,
      })
    end,
  },
}
