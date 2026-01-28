return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
        jdtls = {
          -- Disable formatting capability for jdtls
          on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        },
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
    "mason-org/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- Add basedpyright to Mason's auto-install list
      vim.list_extend(opts.ensure_installed, { "basedpyright" })
    end,
  },
}
