-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.api.nvim_set_hl(0, "CoverageCovered", { fg = "#90EE90" })
vim.api.nvim_set_hl(0, "CoverageUncovered", { fg = "#FFB6C1" })
vim.api.nvim_set_hl(0, "CoveragePartial", { fg = "#FFD700" })

vim.cmd("colorscheme nordic")
