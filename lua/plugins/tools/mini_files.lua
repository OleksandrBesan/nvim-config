return {
  "echasnovski/mini.files",
  version = false,
  config = function()
    local mf = require("mini.files")

    mf.setup({
      mappings = {
        close         = "<Esc>" ,
        go_in         = "l",
        go_in_plus    = "<CR>",
        go_out        = "h",
        go_out_plus   = "H",
        reset         = "<BS>",
        reveal_cwd    = "@",
        show_help     = "g?",
        synchronize   = "=",
        trim_left     = "<",
        trim_right    = ">",
      },
      options = {
        use_as_default_explorer = true,
        permanent_delete = false,
      },
    })

    --
    -- Keymaps are now defined in lua/config/keymaps.lua
    -----------------------------------------------------------------------

    -- Helper: open a path with the system file opener
    local function system_open(path)
      if vim.ui.open then
        vim.ui.open(path)
      else
        -- fallback for older Neovim
        local cmd
        if vim.fn.has("mac") == 1 then
          cmd = { "open", path }
        elseif vim.fn.has("win32") == 1 then
          cmd = { "cmd.exe", "/c", "start", "", path }
        else
          cmd = { "xdg-open", path }
        end
        vim.fn.jobstart(cmd, { detach = true })
      end
    end

    -- BOOKMARK NAVIGATION
    -----------------------------------------------------------------------
    -- Extra shortcuts for quick bookmark navigation
    -- MiniFiles has built-in bookmark keys:
    --  - Press `m<char>` (e.g., `ma`) to set a bookmark
    --  - Press `'<char>` (e.g., `'a`) to jump to the bookmark
    -- No Lua API is needed for bookmarks.
  end,
}
