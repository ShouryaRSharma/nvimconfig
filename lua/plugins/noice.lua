return {
  "folke/noice.nvim",
  opts = function(_, opts)
    -- Preserve existing options
    opts.lsp = opts.lsp or {}
    opts.routes = opts.routes or {}
    opts.presets = opts.presets or {}

    -- Add the new filter for "Registered" messages
    table.insert(opts.routes, {
      filter = {
        event = "notify",
        find = "^Registered",
      },
      opts = { skip = true },
    })

    -- Return the modified opts
    return opts
  end,
}
