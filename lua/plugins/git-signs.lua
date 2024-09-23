return {
  "lewis6991/gitsigns.nvim",
  opts = function(_, opts)
    -- Set up the custom highlight group
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        -- Check if terminal supports italics
        local italic = vim.fn.has("gui") == 1 or vim.fn.exists("&termguicolors") == 1 and vim.o.termguicolors

        -- Define the highlight group with a slightly grey color
        vim.api.nvim_set_hl(0, "CustomGitBlame", {
          fg = "#999999", -- Slightly grey color
          italic = italic,
          default = true,
        })

        -- Force italic using ctermfg and guifg
        vim.cmd([[highlight CustomGitBlame guifg=#999999 ctermfg=246 gui=italic cterm=italic]])

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
