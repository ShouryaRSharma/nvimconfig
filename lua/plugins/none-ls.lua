return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local nls = require("null-ls")
    opts.sources = opts.sources or {}
    table.insert(
      opts.sources,
      nls.builtins.formatting.prettier.with({
        filetypes = { "markdown" },
        extra_args = {
          "--print-width",
          "80",
          "--prose-wrap",
          "always",
        },
      })
    )
  end,
}
