-- read the docs: https://www.lunarvim.org/docs/configuration
-- example configs: https://github.com/lunarvim/starter.lvim
-- video tutorials: https://www.youtube.com/watch?v=sfa9kx-ud_c&list=plhoh5vyxr6qqgu0i7tt_xovk9v-kvz3m6
-- forum: https://www.reddit.com/r/lunarvim/
-- discord: https://discord.com/invite/xb9b4ny
vim.g.mapleader = " "
vim.g.maplocalleader = " "

lvim.plugins = {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "insertenter",
  },
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  {
    "sindrets/diffview.nvim",
    event = "bufread",
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = "nvim-treesitter/nvim-treesitter",
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  },
  {
    "mfussenegger/nvim-dap-python",
  },
  {
    "TimUntersberger/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = "Neogit",
    config = function()
      require("neogit").setup({
        integrations = {
          diffview = true
        }
      })
    end
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter"
    },
  },
  {
    "nvim-neotest/neotest-python",
  },
  {
    "hdiniz/vim-gradle",
    ft = {"gradle", "groovy"},
  },
}

-- Colour Scheme
lvim.colorscheme = "tokyonight"
vim.g.tokyonight_style = "storm" -- Other options: "night", "day"
vim.g.tokyonight_italic_functions = true
vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" }

-- Treesitter closing
lvim.builtin.treesitter.textobjects = {
  select = {
    enable = true,
    lookahead = true,
    keymaps = {
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
    },
  },
}

lvim.builtin.treesitter.ensure_installed = {
  "java",
  "python",
}
lvim.builtin.treesitter.highlight.enable = true

lvim.builtin.treesitter.folding = {
  enable = true
}

-- Github Copilot
local ok, copilot = pcall(require, "copilot")
if not ok then
  return
end

copilot.setup {
  suggestion = {
    keymap = {
      accept = "<c-l>",
      next = "<c-j>",
      prev = "<c-k>",
      dismiss = "<c-h>",
    },
  },
}

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<c-s>", "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<cr>", opts)

-- Terminal keybinds
lvim.builtin.which_key.mappings["t"] = {
  name = "+terminal",
  f = { "<cmd>ToggleTerm<cr>", "floating terminal" },
  v = { "<cmd>ToggleTerm direction=vertical<cr>", "split vertical" },
  h = { "<cmd>ToggleTerm direction=horizontal<cr>", "split horizontal" },
} 

-- function to set terminal keymaps
function _G.set_terminal_keymaps()
  local term_opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<c-\><c-n>]], term_opts)
  vim.keymap.set('t', 'jk', [[<c-\><c-n>]], term_opts)
  vim.keymap.set('t', '<c-h>', [[<cmd>wincmd h<cr>]], term_opts)
  vim.keymap.set('t', '<c-j>', [[<cmd>wincmd j<cr>]], term_opts)
  vim.keymap.set('t', '<c-k>', [[<cmd>wincmd k<cr>]], term_opts)
  vim.keymap.set('t', '<c-l>', [[<cmd>wincmd l<cr>]], term_opts)
end

-- autocommand to set terminal keymaps when entering terminal mode
vim.cmd('autocmd! termopen term://* lua set_terminal_keymaps()')

-- Autosave configuration
local autosave = vim.api.nvim_create_augroup("autosave", { clear = true })

-- Global variable to control autosave
vim.g.autosave_enabled = true

-- Function to toggle autosave
function ToggleAutosave()
  vim.g.autosave_enabled = not vim.g.autosave_enabled
  if vim.g.autosave_enabled then
    vim.api.nvim_echo({{"Autosave enabled", "MoreMsg"}}, false, {})
  else
    vim.api.nvim_echo({{"Autosave disabled", "WarningMsg"}}, false, {})
  end
end

-- Command to toggle autosave
vim.api.nvim_create_user_command("ToggleAutosave", ToggleAutosave, {})

-- Function to check if the current file is the Neovim config
local function is_config_file()
  local config_path = vim.fn.stdpath("config")
  local current_file = vim.fn.expand("%:p")
  return vim.startswith(current_file, config_path)
end

-- Autosave function
local function autosave_handler()
  if not vim.g.autosave_enabled then return end
  local timer = vim.loop.new_timer()
  timer:start(150, 0, vim.schedule_wrap(function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand("%") ~= "" and not is_config_file() then
      vim.cmd("silent! write")
      vim.api.nvim_echo({{"File autosaved", "MoreMsg"}}, false, {})
    end
    timer:close()  -- Always close the timer to prevent memory leaks
  end))
end

-- Set up autocommands for autosave
vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  group = autosave,
  pattern = "*",
  callback = autosave_handler,
})

-- Disable autosave for certain filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = autosave,
  pattern = { "neo-tree", "TelescopePrompt", "toggleterm", "Trouble", "lazy", "packer", "notify" },
  callback = function()
    vim.b.noautosave = true
  end,
})

-- Disable autosave for files in certain directories
vim.api.nvim_create_autocmd("BufNewFile", {
  group = autosave,
  pattern = "/tmp/*",
  callback = function()
    vim.b.noautosave = true
  end,
})

-- Optional: add a keybinding to toggle autosave
lvim.keys.normal_mode["<leader>ta"] = ":ToggleAutosave<CR>"

lvim.builtin.telescope.defaults = {
  wrap_results = true,
}

vim.diagnostic.config({
  float = {
    width = 120,  -- adjust as needed
    wrap = true,
  },
  virtual_text = {
    prefix = '■',
    format = function(diagnostic)
      local message = diagnostic.message
      local truncated_message = string.sub(message, 1, 75)
      if truncated_message ~= message then
        truncated_message = truncated_message .. "..."
      end
      return truncated_message
    end,
  },
})

local utils = require('user.utils')

-- Setup DAP (Debug Adapter Protocol)
local dap = require('dap')

lvim.builtin.dap.active = true
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
pcall(function()
 require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
end)

-- Configure DAP for Java debugging
dap.configurations.java = {
  {
    type = 'java';
    request = 'attach';
    name = "Debug (Attach) - Remote";
    hostName = "127.0.0.1";
    port = 5005;
  },
}

-- Setup DAP for Java
local function setup_dap_java()
  require('jdtls').setup_dap({ hotcodereplace = 'auto' })
  require('jdtls.dap').setup_dap_main_class_configs()
end

-- Call setup_dap_java after JDTLS is attached
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local client = vim.lsp.get_active_clients({bufnr = bufnr, name = "jdtls"})[1]
    if client then
      setup_dap_java()
    end
  end,
})

-- Configure Java formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "google_java_format", filetypes = { "java" } },
}

-- Add gradle-specific configuration
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.gradle", "*.gradle.kts"},
  callback = function()
    vim.bo.filetype = "gradle"
  end,
})

-- Disable pyright in favor of pylsp
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })

-- Ensure pylsp is the only Python LSP
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
  return server ~= "pylsp"
end, lvim.lsp.automatic_configuration.skipped_servers)
-- Configure pylsp 
local lspconfig = require("lspconfig")

lspconfig.pylsp.setup({
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
        -- Enable Jedi for completions and other features
        jedi_completion = {
          enabled = true,
          fuzzy = true,
        },
        jedi_hover = { enabled = true },
        jedi_references = { enabled = true },
        jedi_signature_help = { enabled = true },
        jedi_symbols = { enabled = true },
      }
    }
  }
})

require("neotest").setup({
  adapters = {
    require("neotest-python")({
      -- Extra arguments for nvim-dap configuration
      -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
      dap = {
        justMyCode = false,
        console = "integratedTerminal",
      },
      args = { "--import-mode=importlib", "--log-level", "DEBUG", "--quiet", "-vvv", "--rootdir=" .. vim.fn.getcwd()},
      runner = "pytest",
      env = function()
        local env = vim.tbl_deep_extend("force", vim.fn.environ(), {
          PYTHONPATH = vim.fn.getcwd() .. ":" .. (vim.env.PYTHONPATH or ""),
        })
        return env
      end,
      python = utils.get_python_path()
    })
  }
})

lvim.builtin.which_key.mappings["d"]["]"] = {
  name = "Testing",
  p = {
    name = "Python",
    m = { function() utils.run_test_with_output() end, "Test Method" },
    M = { function() utils.run_test_with_output({strategy = "dap"}) end, "Test Method DAP" },
    f = { function() utils.run_test_with_output(vim.fn.expand('%')) end, "Test File" },
    F = { function() utils.run_test_with_output({vim.fn.expand('%'), strategy = "dap"}) end, "Test File DAP" },
    a = { utils.run_all_tests, "Test All" },
  },
  j = {
    name = "Java",
    s = { "<cmd>lua require'jdtls'.test_class()<CR>", "Test Class" },
    m = { "<cmd>lua require'jdtls'.test_nearest_method()<CR>", "Test Method" },
  },
  S = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary" },
  O = { "<cmd>lua require('neotest').output_panel.toggle()<cr>", "Toggle Output Panel" },
}

function _G.code_action_with_import_priority()
  local actions = vim.lsp.buf.code_action()
  if actions then
    local import_actions = vim.tbl_filter(function(action)
      return action.title:lower():match("import")
    end, actions)
    local actions_to_show = #import_actions > 0 and import_actions or actions
    vim.ui.select(actions_to_show, {
      prompt = "Code actions:",
      format_item = function(item)
        return item.title
      end,
    }, function(choice)
      if choice then
        vim.lsp.buf.execute_command(choice.command)
      end
    end)
  else
    vim.notify("No code actions available", vim.log.levels.INFO)
  end
end

-- Map Alt+Enter to show code actions with import priority
lvim.keys.normal_mode["<M-CR>"] = ":lua _G.code_action_with_import_priority()<CR>"
lvim.keys.insert_mode["<M-CR>"] = "<C-O>:lua _G.code_action_with_import_priority()<CR>"

-- Java-specific LSP settings
lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
  return server ~= "jdtls"
end, lvim.lsp.automatic_configuration.skipped_servers)


local java_on_attach = function(client, bufnr)

  -- Set up your Java-specific mappings here
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local opts = { noremap=true, silent=true }

  buf_set_keymap("n", "<leader>Jo", "<cmd>lua require'jdtls'.organize_imports()<CR>", opts)
  buf_set_keymap("n", "<leader>Jv", "<cmd>lua require('jdtls').extract_variable()<CR>", opts)
  buf_set_keymap("n", "<leader>Jc", "<cmd>lua require('jdtls').extract_constant()<CR>", opts)
  buf_set_keymap("n", "<leader>Jt", "<cmd>lua require'jdtls'.test_nearest_method()<CR>", opts)
  buf_set_keymap("n", "<leader>JT", "<cmd>lua require'jdtls'.test_class()<CR>", opts)
  buf_set_keymap("n", "<leader>Ju", "<cmd>JdtUpdateConfig<CR>", opts)

  buf_set_keymap("v", "<leader>Jv", "<esc><cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
  buf_set_keymap("v", "<leader>Jc", "<esc><cmd>lua require('jdtls').extract_constant(true)<CR>", opts)
  buf_set_keymap("v", "<leader>Jm", "<esc><cmd>lua require('jdtls').extract_method(true)<CR>", opts)

  -- Manually add the which-key group for Java
  local status_ok, which_key = pcall(require, "which-key")
  if status_ok then
    local mappings = {
      J = {
        name = "Java",
        o = "Organize Imports",
        v = "Extract Variable",
        c = "Extract Constant",
        t = "Test Method",
        T = "Test Class",
        u = "Update Config",
        m = "Extract Method",
      },
    }
    local opts = {
      mode = "n", -- Normal mode
      prefix = "<leader>",
      buffer = bufnr, -- Local to buffer
      silent = true,
      noremap = true,
      nowait = true,
    }
    which_key.register(mappings, opts)
  end

  vim.notify("Java environment setup complete", vim.log.levels.INFO)
end

lvim.lsp.on_attach_callback = function(client, bufnr)
  if client.name == "jdtls" then
    java_on_attach(client, bufnr)
  end
end

