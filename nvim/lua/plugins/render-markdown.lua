return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    checkbox = {
      enabled = true,
      -- Configure the 5 default obsidian.nvim checkbox states
      unchecked = {
        icon = "󰄱 ", -- Empty checkbox (matches obsidian.nvim " " state)
        highlight = "ObsidianTodo", -- Use obsidian.nvim highlight group
      },
      checked = {
        icon = "", -- Checked checkbox (matches obsidian.nvim "x" state)
        highlight = "ObsidianDone", -- Use obsidian.nvim highlight group
      },
      custom = {
        -- Obsidian.nvim "~" state (tilde/strikethrough)
        tilde = {
          raw = "[~]",
          rendered = "󰰱",
          highlight = "ObsidianTilde",
        },
        -- Obsidian.nvim "!" state (important)
        important = {
          raw = "[!]",
          rendered = "",
          highlight = "ObsidianImportant",
        },
        -- Obsidian.nvim ">" state (forwarded/right arrow)
        forwarded = {
          raw = "[>]",
          rendered = "",
          highlight = "ObsidianRightArrow",
        },
      },
    },
    -- Define the same highlight groups as obsidian.nvim
    hl_groups = {
      ObsidianTodo = { bold = true, fg = "#f78c6c" },
      ObsidianDone = { bold = true, fg = "#89ddff" },
      ObsidianRightArrow = { bold = true, fg = "#f78c6c" },
      ObsidianTilde = { bold = true, fg = "#ff5370" },
      ObsidianImportant = { bold = true, fg = "#d73128" },
    },
  },
}
