-- read the docs: https://www.lunarvim.org/docs/configuration
-- example configs: https://github.com/lunarvim/starter.lvim
-- video tutorials: https://www.youtube.com/watch?v=sfa9kx-ud_c&list=plhoh5vyxr6qqgu0i7tt_xovk9v-kvz3m6
-- forum: https://www.reddit.com/r/lunarvim/
-- discord: https://discord.com/invite/xb9b4ny
vim.g.mapleader = " "
vim.g.maplocalleader = " "

lvim.plugins = {
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup()
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "insertenter",
  },
  {
    "nvim-java/nvim-java",
    dependencies = {
      "neovim/nvim-lspconfig",
      'nvim-java/lua-async-await',
      'nvim-java/nvim-java-refactor',
      'nvim-java/nvim-java-core',
      'nvim-java/nvim-java-test',
      'nvim-java/nvim-java-dap',
      'MunifTanjim/nui.nvim',
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      {
        'JavaHello/spring-boot.nvim',
        commit = '218c0c26c14d99feca778e4d13f5ec3e8b1b60f0',
      },
      {
        'williamboman/mason.nvim',
        opts = {
          registries = {
            'github:nvim-java/mason-registry',
            'github:mason-org/mason-registry',
          },
        },
      },
      opts = {
        servers = {
          jdtls = {
            settings = {
              java = {
                configuration = {
                  runtimes = {
                    {
                      name = "JavaSE-17",
                      path = "/opt/homebrew/opt/openjdk@17/bin/java",
                      default = true
                    },
                    {
                      name = "JavaSE-11",
                      path = "/opt/homebrew/opt/openjdk@11/bin/java",
                    }
                  }
                }
              },
            },
          },
        },
        setup = {
          jdtls = function()
            require("java").setup()
          end,
        },
      },
    },
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
    "mfussenegger/nvim-dap-python",
  },
  {
    "TimUntersberger/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = "Neogit",
    config = function()
      require("neogit").setup({
        integrations = { diffview = true
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
  {
    "mbbill/undotree"
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
    },
  },
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
  }
}

require("cyberdream").setup({
  transparent = true,
  italic_comments = true,
  hide_fillchars = true,
  borderless_telescope = true,
})

require("notify").setup({
  background_colour = "#000000",
})

require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
    progress = {
      enabled = false
    }
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = false, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = false, -- long messages will be sent to a split
    inc_rename = true, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
})

-- Colour Scheme
lvim.colorscheme = "cyberdream"

lvim.builtin.telescope.defaults = {
  layout_strategy = "horizontal",
  layout_config = {
    horizontal = {
      prompt_position = "top",
      preview_width = 0.55,
      results_width = 0.8,
    },
    vertical = {
      mirror = false,
    },
    width = 0.87,
    height = 0.80,
    preview_cutoff = 120,
  },
  border = false,
  borderchars = {
    prompt = { " ", " ", " ", " ", " ", " ", " ", " " },
    results = { " ", " ", " ", " ", " ", " ", " ", " " },
    preview = { " ", " ", " ", " ", " ", " ", " ", " " },
  },
}

lvim.builtin.telescope.pickers = {
  find_files = {
    theme = "dropdown",
    borderchars = {
      prompt = { " ", " ", " ", " ", " ", " ", " ", " " },
      results = { " ", " ", " ", " ", " ", " ", " ", " " },
      preview = { " ", " ", " ", " ", " ", " ", " ", " " },
    },
  },
  -- Add more pickers here if needed
}

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

local which_key = lvim.builtin.which_key.mappings
local existing_s_mappings = which_key["s"] or {}
existing_s_mappings["z"] = {"<cmd>UndotreeToggle<cr>", "Undo Tree"}
which_key["s"] = existing_s_mappings
which_key["x"] = {
  name = "Trouble",
  x = { "<cmd>Trouble diagnostics toggle<cr>", "Toggle Diagnostics" },
  X = { "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Toggle Buffer Diagnostics" },
  L = { "<cmd>Trouble loclist toggle<cr>", "Toggle Location List" },
  Q = { "<cmd>Trouble qflist toggle<cr>", "Toggle Quickfix List" },
}

lvim.builtin.which_key.mappings = which_key

-- Python refactoring
lvim.builtin.which_key.mappings["r"] = {
  name = "Refactor",
  r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
  a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
  e = { function()
    vim.lsp.buf.code_action({
      context = {
        only = { "refactor.extract" },
        diagnostics = {},
      },
    })
  end, "Extract", mode = "v" },
  i = { function()
    vim.lsp.buf.code_action({
      context = {
        only = { "refactor.inline" },
        diagnostics = {},
      },
    })
  end, "Inline" },
  o = { function()
    vim.lsp.buf.code_action({
      context = {
        only = { "source.organizeImports" },
        diagnostics = {},
      },
    })
  end, "Organize Imports" },
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

-- Add gradle-specific configuration
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = {"*.gradle", "*.gradle.kts"},
  callback = function()
    vim.bo.filetype = "gradle"
  end,
})

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

local existing_d_mappings = lvim.builtin.which_key.mappings["d"] or {}
local testing_mappings = {
  T = {
    name = "Python Test",
    m = { function() utils.run_test_with_output() end, "Method" },
    f = { function() utils.run_test_with_output(vim.fn.expand('%')) end, "File" },
    a = { utils.run_all_tests, "All" },
    d = { function() utils.run_test_with_output({strategy = "dap"}) end, "Method (DAP)" },
    D = { function() utils.run_test_with_output({vim.fn.expand('%'), strategy = "dap"}) end, "File (DAP)" },
  },
  S = { require('neotest').summary.toggle, "Test Summary" },
  O = { require('neotest').output_panel.toggle, "Output Panel" },
}
local merged_mappings = vim.tbl_deep_extend("force", existing_d_mappings, testing_mappings)
lvim.builtin.which_key.mappings["d"] = merged_mappings

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

local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-t>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)

local function toggle_telescope(harpoon_files)
    local finder = function()
        local paths = {}
        for _, item in ipairs(harpoon_files.items) do
            table.insert(paths, item.value)
        end

        return require("telescope.finders").new_table({
            results = paths,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry,
                    ordinal = entry,
                    filename = vim.fn.expand(entry), -- Ensure it's the absolute path
                }
            end,
        })
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = finder(),
        previewer = require("telescope.previewers").vim_buffer_cat.new({
            -- This allows for Tree-sitter syntax highlighting
            get_buffer_by_name = function(_, entry)
                return entry.filename
            end,
        }),
        sorter = require("telescope.config").values.generic_sorter({}),
        layout_config = {
            height = 0.6,
            width = 0.8,
            prompt_position = "top",
            preview_cutoff = 20,
        },
        attach_mappings = function(prompt_bufnr, map)
            map("i", "<C-d>", function()
                local state = require("telescope.actions.state")
                local selected_entry = state.get_selected_entry()
                local current_picker = state.get_current_picker(prompt_bufnr)

                table.remove(harpoon_files.items, selected_entry.index)
                current_picker:refresh(finder())
            end)
            return true
        end,
    }):find()
end

vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window with preview" })
