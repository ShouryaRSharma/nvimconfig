return {
  {
    "andythigpen/nvim-coverage",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("coverage").setup({
        load_coverage_on_start = false,
        auto_reload = true,
        signs = {
          covered = { hl = "CoverageCovered", text = "▎" },
          uncovered = { hl = "CoverageUncovered", text = "▎" },
          partial = { hl = "CoveragePartial", text = "▎" },
        },
        lang = {
          python = {
            coverage_file = ".coverage",
          },
        },
      })
    end,
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          args = {
            "--cov",
            "--cov-report=term-missing",
            "--cov-config=" .. vim.fn.expand("~/.config/nvim/coverage.rc"),
          },
        },
      },
    },
  },
}
