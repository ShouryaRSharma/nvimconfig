return {
  "saghen/blink.cmp",
  dependencies = {
    "onsails/lspkind-nvim",
  },
  opts = {
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 250,
        treesitter_highlighting = true,
        window = { border = "rounded" },
      },
      menu = {
        border = "rounded",
        cmdline_position = function()
          if vim.g.ui_cmdline_pos ~= nil then
            local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
            return { pos[1] - 1, pos[2] }
          end
          local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
          return { vim.o.lines - height, 0 }
        end,
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind" },
          },
        },
      },
    },
    signature = {
      enabled = true,
      window = { border = "rounded" },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot" },
    },
    keymap = {
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },

      ["<Tab>"] = {
        function(cmp)
          -- 1. Try Sidekick Edit Suggestions First
          local ok, sidekick = pcall(require, "sidekick")
          if ok then
            -- We call the function and check if it successfully handled the keypress
            if sidekick.nes_jump_or_apply() then
              return true
            end
          end

          -- 2. If no edit, handle Snippets
          if cmp.snippet_active() then
            return cmp.snippet_forward()
          end

          -- 3. If no snippet, handle the Completion Menu
          if cmp.is_menu_visible() then
            return cmp.select_next()
          end

          -- 4. Native Inline completions (Ghost text)
          if vim.lsp.inline_completion and vim.lsp.inline_completion.get() then
            vim.lsp.inline_completion.accept()
            return true
          end
        end,
        "fallback",
      },

      ["<S-Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.snippet_backward()
          end
          if cmp.is_menu_visible() then
            return cmp.select_prev()
          end
        end,
        "fallback",
      },

      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback" },
      ["<C-n>"] = { "select_next", "fallback" },
      ["<C-up>"] = { "scroll_documentation_up", "fallback" },
      ["<C-down>"] = { "scroll_documentation_down", "fallback" },
    },
  },
}
