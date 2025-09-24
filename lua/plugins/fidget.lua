return {
  "j-hui/fidget.nvim",
  tag = "v1.0.0", -- Make sure to update this to something recent!
  opts = {
    -- options
      notification = {
        override_vim_notify = true,
      },
      integration = {
        ["nvim-tree"] = {
          enable = true,              -- Integrate with nvim-tree/nvim-tree.lua (if installed)
        },
      },
      timer = {
        fidget_decay = 30000, -- Time in milliseconds (20 seconds)
      },
  },
  priority = 100000, -- Load this plugin last
}
