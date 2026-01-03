return {
  "echasnovski/mini.files",
  version = false,
  config = function()
    local mf = require("mini.files")

    -- Clipboard for multi-file copy operations
    local clipboard = {}

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

    -- MULTI-FILE COPY/PASTE
    -----------------------------------------------------------------------
    -- Yank files to clipboard (visual mode)
    local function yank_files()
      clipboard = {}
      -- Get selection range while still in visual mode
      local start_line = vim.fn.line("v")
      local end_line = vim.fn.line(".")
      -- Ensure correct order
      if start_line > end_line then
        start_line, end_line = end_line, start_line
      end

      for lnum = start_line, end_line do
        local entry = mf.get_fs_entry(0, lnum)
        if entry then
          table.insert(clipboard, entry.path)
        end
      end
      vim.notify(string.format("Yanked %d item(s)", #clipboard), vim.log.levels.INFO)
      -- Return to normal mode
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    end

    -- Paste files from clipboard to current directory
    local function paste_files()
      if #clipboard == 0 then
        vim.notify("Clipboard is empty", vim.log.levels.WARN)
        return
      end

      -- Get target directory from current mini.files state
      local target_dir
      local cur_entry = mf.get_fs_entry()

      if cur_entry and cur_entry.fs_type == "directory" then
        -- Cursor on a folder: paste into that folder
        target_dir = cur_entry.path
      else
        -- Cursor on a file or empty: paste into the directory we're currently viewing
        local state = mf.get_explorer_state()
        if state and state.branch and #state.branch > 0 then
          target_dir = state.branch[#state.branch]
        elseif cur_entry then
          target_dir = vim.fn.fnamemodify(cur_entry.path, ":h")
        end
      end

      if not target_dir then
        vim.notify("No valid target directory", vim.log.levels.ERROR)
        return
      end

      local copied = 0
      for _, src in ipairs(clipboard) do
        local name = vim.fn.fnamemodify(src, ":t")
        local dest = target_dir .. "/" .. name

        -- Avoid overwriting: append _copy if exists
        if vim.fn.filereadable(dest) == 1 or vim.fn.isdirectory(dest) == 1 then
          local base = vim.fn.fnamemodify(name, ":r")
          local ext = vim.fn.fnamemodify(name, ":e")
          if ext ~= "" then
            dest = target_dir .. "/" .. base .. "_copy." .. ext
          else
            dest = target_dir .. "/" .. name .. "_copy"
          end
        end

        -- Copy using system command
        local cmd
        if vim.fn.isdirectory(src) == 1 then
          cmd = { "cp", "-R", src, dest }
        else
          cmd = { "cp", src, dest }
        end

        local result = vim.fn.system(cmd)
        if vim.v.shell_error == 0 then
          copied = copied + 1
        else
          vim.notify("Failed to copy: " .. src .. "\n" .. result, vim.log.levels.ERROR)
        end
      end

      vim.notify(string.format("Pasted %d/%d item(s)", copied, #clipboard), vim.log.levels.INFO)
      mf.synchronize()
    end

    -- Delete multiple files (visual mode)
    local function delete_files()
      local start_line = vim.fn.line("v")
      local end_line = vim.fn.line(".")
      if start_line > end_line then
        start_line, end_line = end_line, start_line
      end

      local count = end_line - start_line + 1
      -- Exit visual mode and delete the lines
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
      vim.cmd(string.format("%d,%ddelete", start_line, end_line))
      vim.notify(string.format("Marked %d item(s) for deletion. Press = to confirm", count), vim.log.levels.INFO)
    end

    -- Set up keymaps when mini.files buffer opens
    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf = args.data.buf_id
        vim.keymap.set("x", "<leader>fy", yank_files, { buffer = buf, desc = "Yank files to clipboard" })
        vim.keymap.set("n", "<leader>fp", paste_files, { buffer = buf, desc = "Paste files from clipboard" })
        vim.keymap.set("x", "<leader>fd", delete_files, { buffer = buf, desc = "Delete selected files" })
      end,
    })

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
