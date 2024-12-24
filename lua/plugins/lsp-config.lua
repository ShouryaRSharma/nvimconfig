return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Disable the default pyright
        pyright = {
          enabled = false,
        },
        -- Configure basedpyright
        basedpyright = {
          enabled = true,
          settings = {
            basedpyright = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              autoImportCompletions = true,
              disableOrganizeImports = true,
            },
          },
          filetypes = { "python" },
          single_file_support = true,
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- Add basedpyright to Mason's auto-install list
      vim.list_extend(opts.ensure_installed, { "basedpyright" })
    end,
  },
}
