return {
  {
    "cdmill/neomodern.nvim"
  },
  {
    "sainnhe/gruvbox-material",
  },
  {
    "neanias/everforest-nvim",
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("everforest").setup({
        background = "soft",
      })
    end,
  },
  { 'projekt0n/github-nvim-theme' },
  { 'nyoom-engineering/oxocarbon.nvim' },
  {
    'andrew-george/telescope-themes',
    config = function()
      require('telescope').load_extension('themes')
    end
  }
}
