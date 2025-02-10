return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    scroll = { enabled = false },
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    indent = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    explorer = {
      enabled = true,
      hidden = true,
    },
    picker = {
      enabled = true,
      files = {
        hidden = true,
      },
      sources = {
        files = {
          hidden = true,
        },
        explorer = {
          hidden = true,
        },
        grep = {
          hidden = true,
        },
      },
      matcher = {
        fuzzy = true,
        smartcase = true,
        ignorecase = true,
        sort_empty = false,
        filename_bonus = true,
        file_pos = true,
        cwd_bonus = false,
        frecency = false,
      },
      toggles = {
        hidden = { icon = "h", value = true },
        ignored = { icon = "i", value = false },
      },
      win = {
        input = {
          keys = {
            ["j"] = { "list_down", mode = { "n" } },
            ["k"] = { "list_up", mode = { "n" } },
            ["<Down>"] = { "list_down", mode = { "n", "i" } },
            ["<Up>"] = { "list_up", mode = { "n", "i" } },
            ["<C-j>"] = { "list_down", mode = { "n", "i" } },
            ["<C-k>"] = { "list_up", mode = { "n", "i" } },
            ["<C-n>"] = { "list_down", mode = { "n", "i" } },
            ["<C-p>"] = { "list_up", mode = { "n", "i" } },
            ["/"] = { "toggle_focus", mode = { "n", "i" } },
            ["<a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            ["j"] = "list_down",
            ["k"] = "list_up",
            ["<Down>"] = "list_down",
            ["<Up>"] = "list_up",
            ["<C-j>"] = "list_down",
            ["<C-k>"] = "list_up",
            ["<C-n>"] = "list_down",
            ["<C-p>"] = "list_up",
            ["/"] = "toggle_focus",
          },
        },
      },
    },
  },
  keys = {
    {
      "<leader>fe",
      function()
        Snacks.explorer({ cwd = LazyVim.root() })
      end,
      desc = "Explorer Snacks (root dir)",
    },
    {
      "<leader>fE",
      function()
        Snacks.explorer()
      end,
      desc = "Explorer Snacks (cwd)",
    },
    { "<leader>e", "<leader>fe", desc = "Explorer Snacks (root dir)", remap = true },
    { "<leader>E", "<leader>fE", desc = "Explorer Snacks (cwd)", remap = true },
  },
}
