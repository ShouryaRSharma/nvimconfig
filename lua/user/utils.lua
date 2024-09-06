-- ~/.config/lvim/lua/user/utils.lua
local M = {}

local neotest = require("neotest")

function M.get_python_path(workspace)
  workspace = workspace or vim.fn.getcwd()

  -- Check for poetry environment
  local poetry_path = vim.fn.trim(vim.fn.system("cd " .. workspace .. " && poetry env info -p 2>/dev/null"))
  if vim.v.shell_error == 0 and poetry_path ~= "" then
    return poetry_path .. "/bin/python"
  end

  -- Check for pipenv environment
  local pipenv_path = vim.fn.trim(vim.fn.system("cd " .. workspace .. " && pipenv --venv 2>/dev/null"))
  if vim.v.shell_error == 0 and pipenv_path ~= "" then
    return pipenv_path .. "/bin/python"
  end

  -- Check for virtual environment in workspace
  if vim.fn.executable(workspace .. '/venv/bin/python') == 1 then
    return workspace .. '/venv/bin/python'
  elseif vim.fn.executable(workspace .. '/.venv/bin/python') == 1 then
    return workspace .. '/.venv/bin/python'
  end

  -- Fallback to system Python
  return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
end

function M.run_all_tests()
  -- Run all found test files
  neotest.run.run(vim.fn.getcwd())
  -- Open the output panel
  neotest.output_panel.open()
end

function M.run_test_with_output(args)
  neotest.run.run(args)
  neotest.output_panel.open()
end

return M
