return {
  "telescope.nvim",
  keys = {
    {
      "<leader>fp",
      function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
      desc = "Find Plugin File",
    },
    {
      "<leader>j",
      "<cmd>Telescope jsonfly<cr>",
      desc = "Open json(fly)",
      ft = { "json", "xml", "yaml" },
      mode = "n"
    },
    {
      "<leader>`",
      function()
        require("telescope.builtin").buffers({
          ignore_current_buffer = false,
          show_all_buffers = true,
          previewer = true,
          sort_mru = true,
        })
      end,
      desc = "Find Buffers",
    },
    { "<leader>\\", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    { "<leader><F2>", "<cmd>Telescope lsp_references<cr>", desc = "LSP References" },
    { "<leader><F3>", "<cmd>Telescope lsp_type_definitions<cr>", desc = "LSP Type Definitions" },
    {
      "<leader>/",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end,
      desc = "Live Grep with Args",
    },
  },
  opts = {
    defaults = {
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
      },
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
      hidden = true,
      path_display = { "smart" },
    },

    pickers = {
      buffers = {
        previewer = false,
        sort_mru = true,
        ignore_current_buffer = true,
        entry_maker = function(entry)
          local bufname = vim.api.nvim_buf_get_name(entry.bufnr)
          local rel = vim.fn.fnamemodify(bufname, ":p:~:.")

          -- Strip Java boilerplate paths
          rel = rel:gsub("src/main/java/", "")
          rel = rel:gsub("src/java/main/", "")

          -- Keep last 3 segments
          local parts = vim.split(rel, "/", { plain = true })
          if #parts > 3 then
            rel = table.concat({ parts[#parts-2], parts[#parts-1], parts[#parts] }, "/")
          end

          local display = string.format("%s %s", entry.flag, rel)
          return {
            value = bufname,
            ordinal = rel,
            display = display,
            bufnr = entry.bufnr,
          }
        end,
      },
    },
  },
  dependencies = {
    "nvim-telescope/telescope-live-grep-args.nvim",
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-project.nvim",
    {
      "Myzel394/jsonfly.nvim",
      event = "VeryLazy",
      config = function(_, _)
        require("lazyvim.util").on_load("telescope.nvim", function()
          require('telescope').load_extension('fzf')
          require("telescope").load_extension("live_grep_args")
          require("telescope").load_extension("project")
          require("telescope").load_extension("themes")
        end)
      end,
    },
  },
  keys = {
    {
      "<leader>fp",
      function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
      desc = "Find Plugin File",
    },
    {
      "<leader>j",
      "<cmd>Telescope jsonfly<cr>",
      desc = "Open json(fly)",
      ft = { "json", "xml", "yaml" },
      mode = "n"
    },
    {
      "<leader>`",
      function()
        require("telescope.builtin").buffers({
          ignore_current_buffer = false,
          show_all_buffers = true,
          previewer = true,
          sort_mru = true,
        })
      end,
      desc = "Find Buffers",
    },
    { "<leader>\\", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    { "<leader><F2>", "<cmd>Telescope lsp_references<cr>", desc = "LSP References" },
    { "<leader><F3>", "<cmd>Telescope lsp_type_definitions<cr>", desc = "LSP Type Definitions" },
    {
      "<leader>/",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end,
      desc = "Live Grep with Args",
    },
    {
      "<leader>p",
      function()
        require("telescope").extensions.project.project()
      end,
      desc = "Projects",
    },
  },
}
