return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  cmd = {
    "ObsidianOpen",
    "ObsidianNew",
    "ObsidianToday",
    "ObsidianSearch",
    "ObsidianQuickSwitch",
  },
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required.
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
    "ibhagwan/fzf-lua",
    "nvim-treesitter/nvim-treesitter",

    -- see below for full list of optional dependencies 👇
  },
  opts = {
    ui = {
      enable = false,
    },
    workspaces = {
      {
        name = "pkm",
        path = "~/vaults/pkm",
      },
    },
  },
  keys = {
    { "<leader>os", "<cmd>ObsidianQuickSwitch<cr>", desc = "Quickly Switch to another note" },
    { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "Create a new note" },
    { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Open today's note" },
    { "<leader>of", "<cmd>ObsidianSearch<cr>", desc = "Search in your vault" },
  },
}
