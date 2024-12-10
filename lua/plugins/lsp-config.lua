return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Disable the default pyright
        -- pyright = false,

        -- Configure basedpyright
        basedpyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "standard",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                autoImportCompletions = true,
                disableOrganizeImports = true,
              },
            },
          },
          -- You can customize the basedpyright setup further here
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
