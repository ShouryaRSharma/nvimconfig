return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    opts = {
      provider = "vertex",
      auto_suggestions_provider = "vertex",
      vendors = {
        ["vertex"] = {
          endpoint = "https://LOCATION-aiplatform.googleapis.com/v1/projects/PROJECT_ID/locations/LOCATION/publishers/google/models",
          model = "gemini-1.5-flash-002",
          api_key_name = "cmd:gcloud auth print-access-token",
          parse_curl_args = function(opts, code_opts)
            if not opts then
              vim.notify("Error: opts is nil", vim.log.levels.ERROR)
              return
            end

            if not opts.endpoint then
              vim.notify("Error: opts.endpoint is missing", vim.log.levels.ERROR)
              return
            end

            local location = vim.fn.getenv("LOCATION")
            if not location or location == "" then
              vim.notify("Warning: LOCATION env var not set, using default", vim.log.levels.WARN)
              location = "default-location"
            end

            local project_id = vim.fn.getenv("PROJECT_ID")
            if not project_id or project_id == "" then
              vim.notify("Warning: PROJECT_ID env var not set, using default", vim.log.levels.WARN)
              project_id = "default-project-id"
            end

            local url = opts.endpoint
            url = url:gsub("LOCATION", location):gsub("PROJECT_ID", project_id)

            local model = opts.model
            if not model then
              vim.notify("Error: model is missing from opts", vim.log.levels.ERROR)
              return
            end

            local body_opts
            ok, err = pcall(function()
              body_opts = vim.tbl_deep_extend("force", {}, {
                generationConfig = {
                  temperature = 0,
                  maxOutputTokens = 8000,
                },
              })
            end)
            if not ok then
              vim.notify("Error creating body_opts: " .. tostring(err), vim.log.levels.ERROR)
              return
            end

            url = url .. "/" .. model .. ":streamGenerateContent?alt=sse"

            local api_key
            ok, err = pcall(function()
              api_key = opts.parse_api_key(opts.api_key_name)
            end)
            if not ok then
              vim.notify("Error getting API key: " .. tostring(err), vim.log.levels.ERROR)
              return
            end
            if not api_key then
              vim.notify("Error: Failed to get API key", vim.log.levels.ERROR)
              return
            end

            local messages
            ok, err = pcall(function()
              messages = require("avante.providers.gemini").parse_messages(code_opts)
            end)
            if not ok then
              vim.notify("Error parsing messages: " .. tostring(err), vim.log.levels.ERROR)
              return
            end

            return {
              url = url,
              headers = {
                ["Authorization"] = "Bearer " .. api_key,
                ["Content-Type"] = "application/json; charset=utf-8",
              },
              body = vim.tbl_deep_extend("force", {}, messages, body_opts),
            }
          end,
          parse_response_data = function(data_stream, event_state, opts)
            local ok, err = pcall(function()
              require("avante.providers.gemini").parse_response(data_stream, event_state, opts)
            end)
            if not ok then
              vim.notify("Error parsing response: " .. tostring(err), vim.log.levels.ERROR)
            end
          end,
        },
      },
    },
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      -- Optional dependencies
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      {
        -- Image pasting support
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        -- Markdown rendering support
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
