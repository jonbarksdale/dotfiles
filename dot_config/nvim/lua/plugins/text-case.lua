return {
  {
    "johmsalas/text-case.nvim",
    config = function()
      local textcase = require("textcase")
      textcase.setup({})

      -- Create the fzf-lua integration
      local function text_case_with_fzf()
        local cases = {
          { name = "Camel Case", action = "textcase.current_word.to_camel_case" },
          { name = "Snake Case", action = "textcase.current_word.to_snake_case" },
          { name = "Kebab Case", action = "textcase.current_word.to_dash_case" },
          { name = "Pascal Case", action = "textcase.current_word.to_pascal_case" },
          { name = "Screaming Snake Case", action = "textcase.current_word.to_constant_case" },
          { name = "Title Case", action = "textcase.current_word.to_title_case" },
          { name = "Path Case", action = "textcase.current_word.to_path_case" },
          { name = "Dot Case", action = "textcase.current_word.to_dot_case" },
          { name = "Space Case", action = "textcase.current_word.to_phrase_case" },
        }

        local actions = {}
        local display_items = {}

        for _, case in ipairs(cases) do
          table.insert(display_items, case.name)
          actions[case.name] = case.action
        end

        require("fzf-lua").fzf_exec(display_items, {
          prompt = "Select Text Case > ",
          actions = {
            ["default"] = function(selected)
              local action = actions[selected[1]]
              if action then
                loadstring("require('" .. action:gsub("%.", "')(") .. ")")()
              end
            end,
          },
        })
      end

      -- Create a user command
      vim.api.nvim_create_user_command("TextCaseFzf", text_case_with_fzf, {})

      -- Optional: Add keymapping
      vim.keymap.set("n", "<leader>ga.", text_case_with_fzf, { desc = "Text Case with FZF" })
    end,
    dependencies = {
      "ibhagwan/fzf-lua",
    },
    keys = {
      "ga", -- Default invocation prefix
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
  },
}
