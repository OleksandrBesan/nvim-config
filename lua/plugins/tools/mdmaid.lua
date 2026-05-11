return {
  "OleksandrBesan/mdmaid.nvim",
  ft = "markdown",
  dependencies = { "nvim-telescope/telescope.nvim" },
  build = "npm install -g mdmaid",
  config = function()
    require("mdmaid").setup()
  end,
}
