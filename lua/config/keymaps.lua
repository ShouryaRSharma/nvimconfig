-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap

-- Add Neogit keymap
keymap.set("n", "<leader>gN", "<cmd>Neogit<CR>", { desc = "Open Neogit" })

-- Add keymap to toggle Kubectl plugin
keymap.set(
  "n",
  "<leader>k",
  '<cmd>lua require("kubectl").toggle()<cr>',
  { noremap = true, silent = true, desc = "Toggle Kubectl" }
)

-- Add keymap to open Dashboard with <leader>a keymap
keymap.set("n", "<leader>a", "<cmd>Dashboard<CR>", { desc = "Open Dashboard" })

-- Add keymap to launch LazyDocker
keymap.set("n", "<leader>cD", "<cmd>LazyDocker<CR>", { desc = "Launch LazyDocker" })

-- Load coverage report
keymap.set("n", "<leader>cL", function()
  vim.cmd("CoverageLoad")
end, { desc = "Load coverage" })
keymap.set("n", "<leader>ct", function()
  vim.cmd("CoverageToggle")
end, { desc = "Toggle coverage" })
