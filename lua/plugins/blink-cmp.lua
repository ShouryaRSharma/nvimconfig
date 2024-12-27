return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 250,
        treesitter_highlighting = true,
        window = { border = "rounded" },
      },
    },
    signature = {
      enabled = true,
      window = { border = "rounded" },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot" },
    },
  },
}
