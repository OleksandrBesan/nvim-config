-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://githutrueb.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.api.nvim_set_keymap("n", "<leader><Tab>s", ":w!<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader><Tab>w", ":w!<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><Tab>z", ":u!<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><Tab>wq", ":wqa!<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><Tab>qq", ":qa!<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader><C>y", '"ay<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader><C>p", '"ap<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>y", '"+y<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>p", '"p<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<leader>`", function()
  require("telescope.builtin").buffers({
    ignore_current_buffer = false,
    show_all_buffers = true,
    previewer = true,
    sort_mru = true,
  })
end, { noremap = true, silent = true, desc = "Find Buffers" })

vim.keymap.set("n", "<leader>tt", ":sp<CR>:terminal<CR>", { noremap = true, silent = true, desc = "Open terminal in horizontal split" })
vim.keymap.set("n", "<leader>tc", ":terminal<CR>", { noremap = true, silent = true, desc = "Open terminal in current buffer" })
-- Track the last floating terminal buffer
local last_float_term_buf = nil

local function open_floating_terminal(buf)
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Use existing buffer or create a new one
  local buf_id = buf or vim.api.nvim_create_buf(false, true)

  -- Create floating window
  local win = vim.api.nvim_open_win(buf_id, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  -- If this is a new terminal, start it
  if not buf then
    vim.fn.termopen(os.getenv("SHELL"))
  end

  vim.cmd("startinsert")

  -- Remember last terminal buffer
  last_float_term_buf = buf_id

  -- Close the floating terminal with <Esc>
  vim.keymap.set("t", "<Esc>", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf_id })
end

-- Open a new floating terminal
vim.keymap.set("n", "<leader>tf", function()
  open_floating_terminal(nil)
end, { noremap = true, silent = true, desc = "Open floating terminal" })

-- Reopen the last floating terminal
vim.keymap.set("n", "<leader>tl", function()
  if last_float_term_buf and vim.api.nvim_buf_is_valid(last_float_term_buf) then
    open_floating_terminal(last_float_term_buf)
  else
    vim.notify("No previous floating terminal", vim.log.levels.WARN)
  end
end, { noremap = true, silent = true, desc = "Reopen last floating terminal" })
vim.api.nvim_set_keymap("n", "<leader><F2>", ":Telescope lsp_references<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><F3>", ":Telescope lsp_type_definitions<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>/", ":lua require('telescope').extensions.live_grep_args.live_grep_args()", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>\\", ":Telescope live_grep<CR>", { noremap = true, silent = true })

-- SQL query text object
vim.api.nvim_set_keymap("v", "<leader><F5>s", "<esc>:lua SelectToFirstSemicolon()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><F5>s", ":<c-u>lua require('commands').SelectToFirstSemicolon()<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader><F5>ec", ":lua ExportQueryToCSV()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><F5>q", ":DB<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><F5><F5>", ":DB<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader><F5>q", ":DB<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader><F5><F5>", ":DB<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><F5>a", ":DBUIFindBuffer<CR>", { noremap = true, silent = true })

function DadbodCompletion()
  local items = vim.fn["dadbod#completion#GetCompletionItems"]()

  for _, item in ipairs(items) do
    vim.notify(item, vim.log.levels.INFO)
    local kind = "Text" -- Default kind

    -- Determine the kind based on the item
    if item.word:match("^select") then
      kind = "Function"
    elseif item.word:match("^from") then
      kind = "Keyword"
    elseif item.word:match("^class") then
      kind = "Keyword"
    elseif item.word:match("^insert") then
      kind = "Function"
    elseif item.word:match("^update") then
      kind = "Function"
    elseif item.word:match("^delete") then
      kind = "Function"
    elseif item.word:match("^create") then
      kind = "Function"
    elseif item.word:match("^table") then
      kind = "Keyword"
    elseif item.word:match("^column") then
      kind = "Field"
    else
      kind = "Variable"
    end

    -- Add kind information to the completion item
    item.kind = kind
    -- Assign a sort priority for each kind
    if kind == "Field" then
      item.sort_priority = 1
    elseif kind == "Keyword" and item.word:match("^table") then
      item.sort_priority = 2
    elseif kind == "Function" and item.word:match("^select") then
      item.sort_priority = 3
    elseif kind == "Keyword" and item.word:match("^from") then
      item.sort_priority = 4
    elseif kind == "Function" then
      item.sort_priority = 5
    else
      item.sort_priority = 6
    end
  end

  table.sort(items, function(a, b)
    return (a.sort_priority or 6) < (b.sort_priority or 6)
  end)
  return items
end

-- Set up the completion with the custom function
vim.api.nvim_set_var("dadbod#completion#GetCompletionItems", "v:lua.DadbodCompletion")

vim.api.nvim_set_keymap('n', '<leader><Tab>p', ':buffer #<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<leader><a><c>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader><a><c>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader><a><a>", "<cmd>CodeCompanionToggle<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader><a><a>", "<cmd>CodeCompanionToggle<cr>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ai", "<cmd>CodeCompanionToggle<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<leader>ai", "<cmd>CodeCompanionToggle<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "ga", "<cmd>CodeCompanionAdd<cr>", { noremap = true, silent = true })
--
vim.api.nvim_set_keymap("n", "<leader>FJ", ":%!jq .<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

vim.keymap.set("v", "<leader>mp", function()
  -- Prompt the user to enter text
  local text = vim.fn.input("Enter text to prepend: ")
  if text == "" then
    vim.notify("No text entered", vim.log.levels.ERROR)
    return
  end

  -- Get the selected range
  local start_line = vim.fn.line("'")
  local end_line = vim.fn.line("'>")

  -- Iterate through the selected lines
  for i = start_line, end_line do
    local line = vim.fn.getline(i)
    vim.fn.setline(i, text .. line)
  end
end, { desc = "Prepend text to selected lines" })

vim.keymap.set("v", "<leader>md", function()
  -- Prompt the user to enter the number of symbols to delete
  local count = tonumber(vim.fn.input("Enter number of symbols to delete: ") )
  if not count or count <= 0 then
    vim.notify("Invalid number entered", vim.log.levels.ERROR)
    return
  end
  -- Run the DeleteSymbols command with the provided count
  vim.cmd("'<,'>DeleteSymbols " .. count)
end, { desc = "Delete symbols from selected lines" })

vim.keymap.set("v", "<leader>me", function()
  -- Prompt the user to enter text
  local text = vim.fn.input("Enter text to insert at edges: ")
  if text == "" then
    vim.notify("No text entered", vim.log.levels.ERROR)
    return
  end
  -- Run the InsertAtEdges command with the provided text
  vim.cmd("'<,'>InsertAtEdges " .. text)
end, { desc = "Insert text at first and last selected lines" })

vim.keymap.set("n", "<leader>pf", function() require("utils.paths").copy_paths('full') end, { noremap = true, silent = true, desc = "Copy full path" })
vim.keymap.set("n", "<leader>pr", function() require("utils.paths").copy_paths('relative') end, { noremap = true, silent = true, desc = "Copy relative path" })
vim.keymap.set("n", "<leader>pw", function() require("utils.paths").copy_paths('workflow') end, { noremap = true, silent = true, desc = "Copy workflow path" })

-- mini.files
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

vim.keymap.set("n", "<leader>e", function()
  require("mini.files").open(mini_files_start_dir())
end, { desc = "Open MiniFiles at session root" })

-- Cyrillic alias for <leader>e (UA layout: 'у' sits on US 'e')
vim.keymap.set("n", "<leader>у", function()
  require("mini.files").open(mini_files_start_dir())
end, { desc = "Open MiniFiles at session root (UA alias)" })

-- Cyrillic aliases for common leader mappings (letter-based duplicates)
-- Terminal helpers
vim.keymap.set("n", "<leader>ее", ":sp<CR>:terminal<CR>", { noremap = true, silent = true, desc = "Open terminal in horizontal split (UA)" })
vim.keymap.set("n", "<leader>ес", ":terminal<CR>", { noremap = true, silent = true, desc = "Open terminal in current buffer (UA)" })
vim.keymap.set("n", "<leader>еа", function()
  open_floating_terminal(nil)
end, { noremap = true, silent = true, desc = "Open floating terminal (UA)" })
vim.keymap.set("n", "<leader>ел", function()
  if last_float_term_buf and vim.api.nvim_buf_is_valid(last_float_term_buf) then
    open_floating_terminal(last_float_term_buf)
  else
    vim.notify("No previous floating terminal", vim.log.levels.WARN)
  end
end, { noremap = true, silent = true, desc = "Reopen last floating terminal (UA)" })

-- Paths helpers
vim.keymap.set("n", "<leader>за", function() require("utils.paths").copy_paths('full') end, { noremap = true, silent = true, desc = "Copy full path (UA)" })
vim.keymap.set("n", "<leader>зк", function() require("utils.paths").copy_paths('relative') end, { noremap = true, silent = true, desc = "Copy relative path (UA)" })
vim.keymap.set("n", "<leader>зц", function() require("utils.paths").copy_paths('workflow') end, { noremap = true, silent = true, desc = "Copy workflow path (UA)" })

-- CodeCompanion
vim.keymap.set("n", "<leader>фш", "<cmd>CodeCompanionToggle<cr>", { noremap = true, silent = true, desc = "AI: Toggle (UA)" })

-- Buffers and window splits
-- New empty buffer
vim.keymap.set("n", "<leader>fb", ":enew<CR>", { noremap = true, silent = true, desc = "New empty buffer" })
vim.keymap.set("n", "<leader>аи", ":enew<CR>", { noremap = true, silent = true, desc = "New empty buffer (UA)" })
-- Splits: horizontal and vertical
vim.keymap.set("n", "<leader>ws", ":split<CR>", { noremap = true, silent = true, desc = "Horizontal split" })
vim.keymap.set("n", "<leader>wv", ":vsplit<CR>", { noremap = true, silent = true, desc = "Vertical split" })
vim.keymap.set("n", "<leader>ці", ":split<CR>", { noremap = true, silent = true, desc = "Horizontal split (UA)" })
vim.keymap.set("n", "<leader>цм", ":vsplit<CR>", { noremap = true, silent = true, desc = "Vertical split (UA)" })

-- Close window
vim.keymap.set("n", "<leader>wd", ":close<CR>", { noremap = true, silent = true, desc = "Close window" })
vim.keymap.set("n", "<leader>цв", ":close<CR>", { noremap = true, silent = true, desc = "Close window (UA)" })

-- Core Cyrillic single-key aliases (UA layout)
-- Paste: 'з' -> 'p', 'З' -> 'P'
vim.keymap.set({ "n", "x" }, "з", "p", { noremap = true, silent = true, desc = "Paste (UA 'з')" })
vim.keymap.set({ "n", "x" }, "З", "P", { noremap = true, silent = true, desc = "Paste before (UA 'З')" })
-- Yank: 'н' -> 'y' (so 'нн' acts like 'yy')
vim.keymap.set({ "n", "x", "o" }, "н", "y", { noremap = true, silent = true, desc = "Yank (UA 'н')" })
-- Delete: 'в' -> 'd', 'В' -> 'D'
vim.keymap.set({ "n", "x", "o" }, "в", "d", { noremap = true, silent = true, desc = "Delete (UA 'в')" })
vim.keymap.set({ "n", "x", "o" }, "В", "D", { noremap = true, silent = true, desc = "Delete line (UA 'В')" })
-- WORD motion for delete/change/yank: 'Ц' -> 'W' (so dЦ == dW)
vim.keymap.set({ "n", "x", "o" }, "Ц", "W", { noremap = true, silent = true, desc = "WORD motion (UA 'Ц')" })

-- Visual-mode navigation aliases
-- b (back word) via 'и'
vim.keymap.set('x', 'и', 'b', { noremap = true, silent = true, desc = "Visual: back word (UA 'и')" })
-- $ (end of line) via ';' and UA letter on that key 'ж'
vim.keymap.set('x', ';', '$', { noremap = true, silent = true, desc = "Visual: end of line via ';'" })
vim.keymap.set('x', 'ж', '$', { noremap = true, silent = true, desc = "Visual: end of line (UA 'ж')" })

-- Mode switching via Cyrillic letters
-- Insert: 'ш' -> 'i', 'Ш' -> 'I'
vim.keymap.set('n', 'ш', 'i', { noremap = true, silent = true, desc = "Enter Insert (UA 'ш')" })
vim.keymap.set('n', 'Ш', 'I', { noremap = true, silent = true, desc = "Insert at line start (UA 'Ш')" })
-- Visual: 'м' -> 'v', 'М' -> 'V'
vim.keymap.set('n', 'м', 'v', { noremap = true, silent = true, desc = "Enter Visual (UA 'м')" })
vim.keymap.set('n', 'М', 'V', { noremap = true, silent = true, desc = "Enter Visual Line (UA 'М')" })

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(ev)
    local buf = ev.data.buf_id
    local mf = require("mini.files")

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

-- mini.splitjoin
vim.keymap.set("n", "g<leader>S", function() require("mini.splitjoin").split() end, { desc = "Split arguments" })
vim.keymap.set("n", "gJ", function() require("mini.splitjoin").join() end, { desc = "Join arguments" })

local M = {}

function M.on_attach(client, bufnr)
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- Keymaps for LSP
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
end

return M
