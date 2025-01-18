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
    keys = {
      {
        "<leader>tT",
        function()
          local neotest = require("neotest")

          local function is_python_environment()
            if vim.env.VIRTUAL_ENV or vim.fn.glob("venv") ~= "" then
              return true
            end

            local python_files = { "pyproject.toml", "requirements.txt", "setup.py" }
            for _, file in ipairs(python_files) do
              if vim.fn.glob(file) ~= "" then
                return true
              end
            end

            return false
          end

          if is_python_environment() then
            neotest.run.run({
              extra_args = {
                "--cov",
                "--cov-report=term-missing",
                "--cov-config=" .. vim.fn.expand("~/.config/nvim/coverage.rc"),
              },
              suite = true,
              cwd = vim.fn.getcwd(),
            })
          else
            neotest.run.run({
              suite = true,
              cwd = vim.fn.getcwd(),
            })
          end

          neotest.summary.open()
        end,
        desc = "Run all tests with coverage",
      },
    },
  },
}
