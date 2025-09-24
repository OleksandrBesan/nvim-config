return {
  "echasnovski/mini.surround",
  version = false,
  config = function()
    require("mini.surround").setup({
      mappings = {
        add = "sa",            -- Add surrounding
        delete = "sd",         -- Delete surrounding
        replace = "sr",        -- Replace surrounding
        find = "sf",           -- Find right surrounding
        find_left = "sF",      -- Find left surrounding
        highlight = "sh",      -- Highlight surrounding
        update_n_lines = "sn", -- Update line count for search
      },
    })
  end,
}
