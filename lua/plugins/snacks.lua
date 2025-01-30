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
    picker = {
      enabled = true,
      sources = {
        files = {
          hidden = true, -- Show hidden/dot files
          ignore_patterns = {
            -- Version control
            ".git/",
            ".hg/",
            ".svn/",

            -- Build outputs
            "build/",
            "dist/",
            "target/",

            -- Dependencies
            "node_modules/",
            "vendor/",

            -- Cache directories
            ".cache/",

            -- Package manager files
            "package-lock.json",
            "yarn.lock",
            "poetry.lock",

            -- Environment files
            ".env",
            ".env.*",

            -- IDE and editor files
            ".idea/",
            ".vscode/",
            "*.swp",
            "*.swo",

            -- OS files
            ".DS_Store",
            "Thumbs.db",
          },
          git_ignore = true,
        },
      },
      layout = {
        cycle = true,
        preset = function()
          return vim.o.columns >= 120 and "default" or "vertical"
        end,
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
      win = {
        input = {
          keys = {
            -- Movement keys
            ["j"] = { "list_down", mode = { "n" } },
            ["k"] = { "list_up", mode = { "n" } },
            ["<Down>"] = { "list_down", mode = { "n", "i" } },
            ["<Up>"] = { "list_up", mode = { "n", "i" } },
            ["<C-j>"] = { "list_down", mode = { "n", "i" } },
            ["<C-k>"] = { "list_up", mode = { "n", "i" } },
            ["<C-n>"] = { "list_down", mode = { "n", "i" } },
            ["<C-p>"] = { "list_up", mode = { "n", "i" } },
            -- Window focus toggle
            ["/"] = { "toggle_focus", mode = { "n", "i" } },
            -- Other keys including hidden toggle
            ["<a-h>"] = { "toggle_hidden", mode = { "i", "n" } },
          },
        },
        list = {
          keys = {
            -- Movement keys
            ["j"] = "list_down",
            ["k"] = "list_up",
            ["<Down>"] = "list_down",
            ["<Up>"] = "list_up",
            ["<C-j>"] = "list_down",
            ["<C-k>"] = "list_up",
            ["<C-n>"] = "list_down",
            ["<C-p>"] = "list_up",
            -- Window focus toggle
            ["/"] = "toggle_focus",
          },
        },
      },
    },
  },
}
