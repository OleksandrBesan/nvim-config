return {
  "folke/flash.nvim",
  opts = {
    modes = {
      char = {
        jump_labels = true,
      },
      search = {
        enabled = true,
      },
    },
  },
  keys = function()
    -- Completely override LazyVim's default keys
    return {
      { "<leader>sf", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "<leader>sF", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    }
  end,
}
