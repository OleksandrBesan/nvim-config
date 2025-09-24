return {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      notify = {
        enabled = false, -- Disable Noice's override of vim.notify
      },
    })
  end,
}
