return {
  "echasnovski/mini.splitjoin",
  version = false,
  config = function()
    require("mini.splitjoin").setup()

    -- Example keymaps
    vim.keymap.set("n", "gS", function() MiniSplitjoin.split() end, { desc = "Split arguments" })
    vim.keymap.set("n", "gJ", function() MiniSplitjoin.join() end, { desc = "Join arguments" })
  end,
}
