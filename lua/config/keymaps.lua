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

vim.api.nvim_set_keymap(
  "n",
  "<leader>/",
  ":Telescope live_grep<CR>",
  { noremap = true, silent = true }
)

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
vim.api.nvim_set_keymap("n", "<leader><F5>s", ":<c-u>lua SelectToFirstSemicolon()<cr>", { noremap = true, silent = true })
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
vim.api.nvim_set_keymap("v", "ga", "<cmd>CodeCompanionAdd<cr>", { noremap = true, silent = true })

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
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  -- Iterate through the selected lines
  for i = start_line, end_line do
    local line = vim.fn.getline(i)
    vim.fn.setline(i, text .. line)
  end
end, { desc = "Prepend text to selected lines" })


vim.keymap.set("v", "<leader>md", function()
  -- Prompt the user to enter the number of symbols to delete
  local count = tonumber(vim.fn.input("Enter number of symbols to delete: "))
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

vim.keymap.set("n", "<leader>pf", function() require("utils").copy_paths('full') end, { noremap = true, silent = true, desc = "Copy full path" })
vim.keymap.set("n", "<leader>pr", function() require("utils").copy_paths('relative') end, { noremap = true, silent = true, desc = "Copy relative path" })
vim.keymap.set("n", "<leader>pw", function() require("utils").copy_paths('workflow') end, { noremap = true, silent = true, desc = "Copy workflow path" })

