return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim", -- Optional
    {
      "stevearc/dressing.nvim",      -- Optional: Improves the default Neovim UI
      opts = {},
    },
  },
  config = true
}
