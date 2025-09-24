-- Set colorscheme
vim.g.lazyvim_colorscheme = "everforest"

-- Load lazy.nvim
require("config.lazy")

-- Load environment variables and API keys
require("env")

-- Load custom commands
require("commands")

-- Setup custom extensions
require("extensions").setup()
