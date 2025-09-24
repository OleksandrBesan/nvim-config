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
  },
  opts = {
    defaults = {
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
  requires = {
    -- Directly require extensions without nesting them inside another config
    "nvim-telescope/telescope-live-grep-args.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzf-native.nvim", -- Assuming you have fzf-native installed for the fzf extension
    "nvim-telescope/telescope-project.nvim",    -- Assuming this is the project extension you meant
  },
  dependencies = {
    {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-project.nvim",
      "Myzel394/jsonfly.nvim",
      event = "VeryLazy",
      config = function(_, _)
        require("lazyvim.util").on_load("telescope.nvim", function()
          require('telescope').load_extension('fzf')
          require("telescope").load_extension("live_grep_args")
          require("telescope").load_extension("projects")
          require("telescope").load_extension("themes")
        end)
      end,
    },
  }
}
