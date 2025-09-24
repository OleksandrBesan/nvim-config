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

    -----------------------------------------------------------------------
    -- Keymaps:
    -- Open MiniFiles in current buffer's directory
    
    vim.g.mini_files_session_root = vim.g.mini_files_session_root or nil
    -- Helper: pick start dir (remember-first, then reuse)
    local function mini_files_start_dir()
      -- If we already set a session root and it still exists, reuse it
      if vim.g.mini_files_session_root and vim.fn.isdirectory(vim.g.mini_files_session_root) == 1 then
        return vim.g.mini_files_session_root
      end
      -- Otherwise, initialize from current buffer's directory and remember it
      local buf_dir = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":p:h")
      if buf_dir == "" then
        buf_dir = vim.loop.cwd() -- fallback to CWD if buffer has no name
      end
      vim.g.mini_files_session_root = buf_dir
      return buf_dir
    end

    -- Replace your existing <leader>e mapping with this:
    vim.keymap.set("n", "<leader>e", function()
      mf.open(mini_files_start_dir())
    end, { desc = "Open MiniFiles at session root" })

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

    -- MiniFiles: buffer-local keymaps to open in OS
    -- gx  -> open the entry under cursor (file or dir) with the system
    -- gX  -> reveal the file's parent directory in the system file manager
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(ev)
        local buf = ev.data.buf_id
        vim.keymap.set("n", "gs", function()
          local entry = mf.get_fs_entry()  -- current row (has .path and .type)
          if not entry then return end
          system_open(entry.path)
        end, { buffer = buf, desc = "Open with system" })

        vim.keymap.set("n", "gS", function()
          local entry = mf.get_fs_entry()
          if not entry then return end
          local path = entry.path
          -- if it's a file, reveal the parent folder; if dir, open the dir itself
          if entry.fs_type == "file" or entry.type == "file" then
            path = vim.fn.fnamemodify(path, ":h")
          end
          system_open(path)
        end, { buffer = buf, desc = "Reveal in system file manager" })

        -- Set session root to current entry (dir) or its parent (file)
        vim.keymap.set("n", "gr", function()
          local entry = mf.get_fs_entry()
          if not entry or not entry.path then return end
          local path = entry.path
          local is_file = (entry.fs_type == "file") or (entry.type == "file")
          if is_file then
            path = vim.fn.fnamemodify(path, ":h")
          end
          if vim.fn.isdirectory(path) == 1 then
            vim.g.mini_files_session_root = path
            vim.notify("MiniFiles session root → " .. path, vim.log.levels.INFO)
          end
        end, { buffer = buf, desc = "Set MiniFiles session root here" })
      end,
    })

    -----------------------------------------------------------------------
    -- BOOKMARK NAVIGATION
    -----------------------------------------------------------------------
    -- Extra shortcuts for quick bookmark navigation
    -- MiniFiles has built-in bookmark keys:
    --  - Press `m<char>` (e.g., `ma`) to set a bookmark
    --  - Press `'<char>` (e.g., `'a`) to jump to the bookmark
    -- No Lua API is needed for bookmarks.
  end,
}
