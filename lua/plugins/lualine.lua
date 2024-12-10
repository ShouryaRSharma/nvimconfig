return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function(_, opts)
    local function lsp_name()
      local msg = "No Active Lsp"
      local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
      if #buf_clients == 0 then
        return msg
      end
      local buf_client_names = {}
      local ft = vim.bo.filetype
      for _, client in pairs(buf_clients) do
        -- Skip copilot, null-ls, and jdtls if not in java file
        if client.name ~= "null-ls" and client.name ~= "copilot" and not (client.name == "jdtls" and ft ~= "java") then
          -- Rename sonarlint.nvim to just sonarlint
          local name = client.name
          if name == "sonarlint.nvim" then
            name = "sonarlint"
          end
          table.insert(buf_client_names, name)
        end
      end
      -- Add null-ls sources
      local null_ls_sources = require("null-ls.sources").get_available(vim.bo.filetype)
      for _, source in ipairs(null_ls_sources) do
        table.insert(buf_client_names, source.name)
      end
      if #buf_client_names == 0 then
        return msg
      end
      return "[" .. table.concat(buf_client_names, ", ") .. "]"
    end
    opts.sections = opts.sections or {}
    opts.sections.lualine_x = opts.sections.lualine_x or {}
    table.insert(opts.sections.lualine_x, {
      lsp_name,
      color = { gui = "bold" },
    })
    opts.theme = "auto"
    return opts
  end,
}
