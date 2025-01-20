return {
  "jiaoshijie/undotree",
  dependencies = "nvim-lua/plenary.nvim",
  config = true,
  keys = {
    { "<leader>sz", "<cmd>lua require('undotree').toggle()<cr>", "Undotree" },
  },
}
