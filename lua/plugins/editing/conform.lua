return {
  "stevearc/conform.nvim",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        lua = { "lua-format" },
        json = { "jq" },
        xml = { "xmlformat" },
        yaml = { "yamlfmt" },
        html = { "htmlbeautifier", "djlint" },
        hcl = { "hcl" },
      },
      format_on_save = {
        -- These options will be passed to conform.format()
        timeout_ms = 500,
        lsp_format = "fallback",
        filter = function(buf)
          -- Exclude `.env` files
          local filename = vim.api.nvim_buf_get_name(buf)
          return not filename:match("%.env$")
        end,
      },
    })
  end,
}
