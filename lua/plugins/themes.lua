return {
  {
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      bold_keywords = true,
      transparent = {
        bg = true,
        float = true,
      },
      -- This MUST be inside the opts table
      on_highlights = function(highlights, palette)
        highlights.StatusLine = { bg = "none" }
        highlights.StatusLineNC = { bg = "none" }
        highlights.MsgArea = { bg = "none" }
      end,
    },
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
}
