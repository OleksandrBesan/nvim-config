return {
  "echasnovski/mini.surround",
  version = false,
  event = "VeryLazy",
  config = function()
    require("mini.surround").setup({
      mappings = {
        add = "<leader>za",     -- Add surrounding (normal: <leader>zaiw", visual: <leader>za")
        delete = "<leader>zd",  -- Delete surrounding (<leader>zd")
        replace = "<leader>zr", -- Replace surrounding (<leader>zr"')
        find = "",
        find_left = "",
        highlight = "",
        update_n_lines = "",
      },
    })
  end,
}
