return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration

    -- Only one of these is needed.
    "nvim-telescope/telescope.nvim", -- optional
    "ibhagwan/fzf-lua", -- optional
    "nvim-mini/mini.pick", -- optional
  },
  keys = {
    {
      "<leader>gg",
      "<cmd>Neogit<cr>",
      desc = "Open Neogit",
    },
  },
  config = true,
}
