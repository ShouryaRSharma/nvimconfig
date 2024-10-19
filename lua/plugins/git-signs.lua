return {
  "lewis6991/gitsigns.nvim",
  opts = function(_, opts)
    -- Set up the custom highlight group
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        -- Define the highlight group with a slightly grey color and italics
        vim.api.nvim_set_hl(0, "CustomGitBlame", {
          fg = "#999999", -- Slightly grey color
          italic = true,
          default = true,
        })
        -- Debug: Print current highlight settings
        print(vim.inspect(vim.api.nvim_get_hl(0, { name = "CustomGitBlame" })))
      end,
    })
    -- Configure GitSigns with the custom formatter
    opts.current_line_blame = true
    opts.current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 0,
    }
    opts.current_line_blame_formatter = function(name, blame_info)
      local author = blame_info.author == name and "You" or blame_info.author
      local text =
        string.format("%s, %s - %s", author, os.date("%Y-%m-%d", tonumber(blame_info.author_time)), blame_info.summary)
      return { { text, "CustomGitBlame" } }
    end
    return opts
  end,
}
