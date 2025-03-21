return {
  --   {
  --     "benlubas/molten-nvim",
  --     version = "^1.0.0",
  --     dependencies = { "3rd/image.nvim" },
  --     build = ":UpdateRemotePlugins",
  --     init = function()
  --       -- Configuration settings for better notebook experience
  --       vim.g.molten_auto_open_output = false
  --       vim.g.molten_image_provider = "image.nvim"
  --       vim.g.molten_wrap_output = true
  --       vim.g.molten_virt_text_output = true
  --       vim.g.molten_virt_lines_off_by_1 = true
  --
  --       -- Set up keymaps for molten
  --       vim.keymap.set(
  --         "n",
  --         "<localleader>e",
  --         ":MoltenEvaluateOperator<CR>",
  --         { desc = "evaluate operator", silent = true }
  --       )
  --       vim.keymap.set(
  --         "n",
  --         "<localleader>os",
  --         ":noautocmd MoltenEnterOutput<CR>",
  --         { desc = "open output window", silent = true }
  --       )
  --       vim.keymap.set("n", "<localleader>rr", ":MoltenReevaluateCell<CR>", { desc = "re-eval cell", silent = true })
  --       vim.keymap.set(
  --         "v",
  --         "<localleader>r",
  --         ":<C-u>MoltenEvaluateVisual<CR>gv",
  --         { desc = "execute visual selection", silent = true }
  --       )
  --       vim.keymap.set("n", "<localleader>oh", ":MoltenHideOutput<CR>", { desc = "close output window", silent = true })
  --       vim.keymap.set("n", "<localleader>md", ":MoltenDelete<CR>", { desc = "delete Molten cell", silent = true })
  --       vim.keymap.set(
  --         "n",
  --         "<localleader>mx",
  --         ":MoltenOpenInBrowser<CR>",
  --         { desc = "open output in browser", silent = true }
  --       )
  --     end,
  --     -- Automatically import/export output chunks
  --     config = function()
  --       -- Automatically import output chunks from a jupyter notebook
  --       local imb = function(e) -- init molten buffer
  --         vim.schedule(function()
  --           local kernels = vim.fn.MoltenAvailableKernels()
  --           local try_kernel_name = function()
  --             local metadata = vim.json.decode(io.open(e.file, "r"):read("a"))["metadata"]
  --             return metadata.kernelspec.name
  --           end
  --           local ok, kernel_name = pcall(try_kernel_name)
  --           if not ok or not vim.tbl_contains(kernels, kernel_name) then
  --             kernel_name = nil
  --             local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
  --             if venv ~= nil then
  --               kernel_name = string.match(venv, "/.+/(.+)")
  --             end
  --           end
  --           if kernel_name ~= nil and vim.tbl_contains(kernels, kernel_name) then
  --             vim.cmd(("MoltenInit %s"):format(kernel_name))
  --           end
  --           vim.cmd("MoltenImportOutput")
  --         end)
  --       end
  --
  --       -- Import output chunks when opening a notebook
  --       vim.api.nvim_create_autocmd("BufAdd", {
  --         pattern = { "*.ipynb" },
  --         callback = imb,
  --       })
  --
  --       -- Catch files opened directly like nvim ./file.ipynb
  --       vim.api.nvim_create_autocmd("BufEnter", {
  --         pattern = { "*.ipynb" },
  --         callback = function(e)
  --           if vim.api.nvim_get_vvar("vim_did_enter") ~= 1 then
  --             imb(e)
  --           end
  --         end,
  --       })
  --
  --       -- Export output chunks on save
  --       vim.api.nvim_create_autocmd("BufWritePost", {
  --         pattern = { "*.ipynb" },
  --         callback = function()
  --           if require("molten.status").initialized() == "Molten" then
  --             vim.cmd("MoltenExportOutput!")
  --           end
  --         end,
  --       })
  --
  --       -- Change Molten settings based on filetype
  --       vim.api.nvim_create_autocmd("BufEnter", {
  --         pattern = "*.py",
  --         callback = function(e)
  --           if string.match(e.file, ".otter.") then
  --             return
  --           end
  --           if require("molten.status").initialized() == "Molten" then
  --             vim.fn.MoltenUpdateOption("virt_lines_off_by_1", false)
  --             vim.fn.MoltenUpdateOption("virt_text_output", false)
  --           else
  --             vim.g.molten_virt_lines_off_by_1 = false
  --             vim.g.molten_virt_text_output = false
  --           end
  --         end,
  --       })
  --
  --       -- Reset Molten settings for notebook files
  --       vim.api.nvim_create_autocmd("BufEnter", {
  --         pattern = { "*.qmd", "*.md", "*.ipynb" },
  --         callback = function(e)
  --           if string.match(e.file, ".otter.") then
  --             return
  --           end
  --           if require("molten.status").initialized() == "Molten" then
  --             vim.fn.MoltenUpdateOption("virt_lines_off_by_1", true)
  --             vim.fn.MoltenUpdateOption("virt_text_output", true)
  --           else
  --             vim.g.molten_virt_lines_off_by_1 = true
  --             vim.g.molten_virt_text_output = true
  --           end
  --         end,
  --       })
  --
  --       -- Provide a command to create a blank new Python notebook
  --       local default_notebook = [[
  --         {
  --           "cells": [
  --            {
  --             "cell_type": "markdown",
  --             "metadata": {},
  --             "source": [
  --               ""
  --             ]
  --            }
  --           ],
  --           "metadata": {
  --            "kernelspec": {
  --             "display_name": "Python 3",
  --             "language": "python",
  --             "name": "python3"
  --            },
  --            "language_info": {
  --             "codemirror_mode": {
  --               "name": "ipython"
  --             },
  --             "file_extension": ".py",
  --             "mimetype": "text/x-python",
  --             "name": "python",
  --             "nbconvert_exporter": "python",
  --             "pygments_lexer": "ipython3"
  --            }
  --           },
  --           "nbformat": 4,
  --           "nbformat_minor": 5
  --         }
  --       ]]
  --
  --       local function new_notebook(filename)
  --         local path = filename .. ".ipynb"
  --         local file = io.open(path, "w")
  --         if file then
  --           file:write(default_notebook)
  --           file:close()
  --           vim.cmd("edit " .. path)
  --         else
  --           print("Error: Could not open new notebook file for writing.")
  --         end
  --       end
  --
  --       vim.api.nvim_create_user_command("NewNotebook", function(opts)
  --         new_notebook(opts.args)
  --       end, {
  --         nargs = 1,
  --         complete = "file",
  --       })
  --     end,
  --   },
  --
  {
    "goerz/jupytext.nvim",
    version = "0.2.0",
    opts = {},
    config = function(_, opts)
      require("jupytext").setup(opts)

      -- Schedule the check to run after Neovim has fully started
      vim.defer_fn(function()
        -- Run the check in a separate thread to avoid blocking the UI
        vim.fn.jobstart("pip list | grep jupytext", {
          on_exit = function(_, code, _)
            -- If jupytext is not installed (exit code 1 means no match found)
            if code == 1 then
              vim.notify("Installing jupytext Python package...", vim.log.levels.INFO)
              -- Install jupytext in the background
              vim.fn.jobstart("pip install jupytext", {
                on_exit = function(_, install_code, _)
                  if install_code == 0 then
                    vim.notify("jupytext Python package installed", vim.log.levels.INFO)
                  else
                    vim.notify("Failed to install jupytext", vim.log.levels.ERROR)
                  end
                end,
              })
            elseif code ~= 0 then
              vim.notify(
                "Failed to check for jupytext package. Please install it manually with 'pip install jupytext'",
                vim.log.levels.WARN
              )
            end
          end,
        })
      end, 1000)
    end,
  },
}
--   {
--     "quarto-dev/quarto-nvim",
--     ft = { "quarto", "markdown" },
--     dependencies = {
--       "jmbuhr/otter.nvim",
--     },
--     opts = {
--       lspFeatures = {
--         languages = { "python", "r", "julia" }, -- Add languages you need
--         chunks = "all",
--         diagnostics = {
--           enabled = true,
--           triggers = { "BufWritePost" },
--         },
--         completion = {
--           enabled = true,
--         },
--       },
--       keymap = {
--         hover = "H",
--         definition = "gd",
--         rename = "<leader>rn",
--         references = "gr",
--         format = "<leader>gf",
--       },
--       codeRunner = {
--         enabled = true,
--         default_method = "molten",
--       },
--     },
--     config = function(_, opts)
--       require("quarto").setup(opts)
--
--       -- Quarto code running keymaps
--       local runner = require("quarto.runner")
--       vim.keymap.set("n", "<localleader>rc", runner.run_cell, { desc = "run cell", silent = true })
--       vim.keymap.set("n", "<localleader>ra", runner.run_above, { desc = "run cell and above", silent = true })
--       vim.keymap.set("n", "<localleader>rA", runner.run_all, { desc = "run all cells", silent = true })
--       vim.keymap.set("n", "<localleader>rl", runner.run_line, { desc = "run line", silent = true })
--       vim.keymap.set("v", "<localleader>r", runner.run_range, { desc = "run visual range", silent = true })
--       vim.keymap.set("n", "<localleader>RA", function()
--         runner.run_all(true)
--       end, { desc = "run all cells of all languages", silent = true })
--
--       -- Create the ftplugin file to activate quarto in markdown buffers
--       local ftplugin_dir = vim.fn.stdpath("config") .. "/ftplugin"
--       if vim.fn.isdirectory(ftplugin_dir) == 0 then
--         vim.fn.mkdir(ftplugin_dir, "p")
--       end
--
--       local md_file = ftplugin_dir .. "/markdown.lua"
--       if vim.fn.filereadable(md_file) == 0 then
--         local f = io.open(md_file, "w")
--         if f then
--           f:write('require("quarto").activate()')
--           f:close()
--         end
--       end
--     end,
--   },
--
--   -- Add treesitter-textobjects for better code cell navigation
--   {
--     "nvim-treesitter/nvim-treesitter",
--     opts = function(_, opts)
--       -- Make sure we have a place to put custom query files
--       local after_dir = vim.fn.stdpath("config") .. "/after"
--       local queries_dir = after_dir .. "/queries"
--       local markdown_dir = queries_dir .. "/markdown"
--
--       if vim.fn.isdirectory(markdown_dir) == 0 then
--         vim.fn.mkdir(markdown_dir, "p")
--       end
--
--       -- Create the text objects file if it doesn't exist
--       local scm_file = markdown_dir .. "/textobjects.scm"
--       if vim.fn.filereadable(scm_file) == 0 then
--         local f = io.open(scm_file, "w")
--         if f then
--           f:write(";; extends\n\n(fenced_code_block (code_fence_content) @code_cell.inner) @code_cell.outer")
--           f:close()
--         end
--       end
--
--       -- Extend the existing LazyVim treesitter configuration
--       -- This is the proper way to add textobjects in LazyVim
--       opts.textobjects = opts.textobjects or {}
--       opts.textobjects.move = opts.textobjects.move or {}
--       opts.textobjects.select = opts.textobjects.select or {}
--       opts.textobjects.swap = opts.textobjects.swap or {}
--
--       -- Set enable=true if not already set
--       opts.textobjects.move.enable = true
--       opts.textobjects.select.enable = true
--       opts.textobjects.swap.enable = true
--
--       -- Extend with our code cell mappings
--       opts.textobjects.move.goto_next_start = opts.textobjects.move.goto_next_start or {}
--       opts.textobjects.move.goto_previous_start = opts.textobjects.move.goto_previous_start or {}
--       opts.textobjects.select.keymaps = opts.textobjects.select.keymaps or {}
--       opts.textobjects.swap.swap_next = opts.textobjects.swap.swap_next or {}
--       opts.textobjects.swap.swap_previous = opts.textobjects.swap.swap_previous or {}
--
--       -- Add our code cell mappings
--       opts.textobjects.move.goto_next_start["]b"] = { query = "@code_cell.inner", desc = "next code block" }
--       opts.textobjects.move.goto_previous_start["[b"] = { query = "@code_cell.inner", desc = "previous code block" }
--       opts.textobjects.select.keymaps["ib"] = { query = "@code_cell.inner", desc = "in block" }
--       opts.textobjects.select.keymaps["ab"] = { query = "@code_cell.outer", desc = "around block" }
--       opts.textobjects.swap.swap_next["<leader>sbl"] = "@code_cell.outer"
--       opts.textobjects.swap.swap_previous["<leader>sbh"] = "@code_cell.outer"
--
--       return opts
--     end,
--   },
-- }
