return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
      suggestion = { enabled = false }, -- CRITICAL: Disable this for blink/sidekick
      panel = { enabled = false },
      filetypes = { ["*"] = true }, -- Ensure it's active everywhere
    },
  },
}
