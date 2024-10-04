-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap

-- Add Neogit keymap
keymap.set("n", "<leader>gN", "<cmd>Neogit<CR>", { desc = "Open Neogit" })

-- Add Neotest keymap to run all tests and open output panel
keymap.set("n", "<leader>tT", function()
  local neotest = require("neotest")
  neotest.run.run(vim.fn.getcwd())
  neotest.output_panel.open()
end, { desc = "Run all tests and open output panel" })

keymap.set(
  "n",
  "<leader>k",
  '<cmd>lua require("kubectl").toggle()<cr>',
  { noremap = true, silent = true, desc = "Toggle Kubectl" }
)
