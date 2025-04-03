-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Add local clear whitespace function
local function clear_whitespace()
  vim.cmd(":%s/\\s\\+$//e")
  vim.cmd(":nohl")
end

local function clear_comments()
  vim.cmd(":%s/\\s*#.*$//e")
  vim.cmd(":nohl")
end

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

-- Add keymap to launch LazyDocker
keymap.set("n", "<leader>cD", "<cmd>LazyDocker<CR>", { desc = "Launch LazyDocker" })

-- Load coverage report
keymap.set("n", "<leader>cL", function()
  vim.cmd("CoverageLoad")
end, { desc = "Load coverage" })
keymap.set("n", "<leader>ct", function()
  vim.cmd("CoverageToggle")
end, { desc = "Toggle coverage" })

-- Keymap to clear trailing whitespaces
keymap.set("n", "<leader>zw", function()
  clear_whitespace()
end, { desc = "Clear trailing whitespaces" })

keymap.set("n", "<leader>zc", function()
  clear_comments()
end, { desc = "Clear comments" })
