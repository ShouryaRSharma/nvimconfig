return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      -- these are examples, not defaults. Please see the readme
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
    end,
  },
  {
    -- see the image.nvim readme for more information about configuring this plugin
    "3rd/image.nvim",
    opts = {
      backend = "kitty", -- whatever backend you would like to use
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true, -- toggles images when windows are overlapped
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },
  {
    "goerz/jupytext.nvim",
    version = "0.2.0",
    opts = {},
    config = function()
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
