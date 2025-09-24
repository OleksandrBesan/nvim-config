return {
  "echasnovski/mini.indentscope",
  version = false,
  config = function()
    require("mini.indentscope").setup({
      symbol = "│",
      draw = { delay = 50 },
      options = { border = "none", indent_at_cursor = true },
    })
  end,
}
