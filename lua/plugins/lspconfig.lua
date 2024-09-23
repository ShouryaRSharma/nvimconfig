return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      pylsp = {
        settings = {
          pylsp = {
            plugins = {
              -- Disable unused plugins
              pycodestyle = { enabled = false },
              pyflakes = { enabled = false },
              mccabe = { enabled = false },
              pylint = { enabled = false },
              yapf = { enabled = false },
              autopep8 = { enabled = false },
              pydocstyle = { enabled = false },
              -- Enable Ruff for linting
              ruff = {
                format = { "I", "E", "F", "W", "C", "D" },
                enabled = true,
                lineLength = 100,
                extendSelect = { "I" },
              },
              -- Enable Rope for auto-import and refactoring
              rope_completion = { enabled = true },
              rope_autoimport = {
                enabled = true,
                completions = { enabled = true },
                code_actions = { enabled = true },
              },
              rope_rename = { enabled = true },
              -- Enable Jedi for completions and other features
              jedi_completion = {
                enabled = true,
                fuzzy = true,
              },
              jedi_hover = { enabled = true },
              jedi_references = { enabled = true },
              jedi_signature_help = { enabled = true },
              jedi_symbols = { enabled = true },
              pylsp_mypy = { enabled = true },
              mypy = {
                enabled = true,
                live_mode = true,
              },
            },
          },
        },
      },
    },
  },
}
