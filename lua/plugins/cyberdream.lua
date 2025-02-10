return {
  "scottmckendry/cyberdream.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("cyberdream").setup({
      transparent = true,
      italic_comments = true,
      hide_fillchars = false,
      borderless_pickers = true,
      terminal_colors = false,
      extensions = {
        snacks = true,
      },
    })
    vim.cmd([[colorscheme cyberdream]])
  end,
}
