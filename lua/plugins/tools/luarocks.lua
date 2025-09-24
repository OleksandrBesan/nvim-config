return {
  "camspiers/luarocks",
  dependencies = {
    "rcarriga/nvim-notify", -- Optional dependency
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua", "magick" }, -- Specify LuaRocks packages to install
  },
}
