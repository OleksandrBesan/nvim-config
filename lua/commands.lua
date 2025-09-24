local M = {}

function M.SelectToFirstSemicolon()
  -- Save current cursor position
  local curpos = vim.api.nvim_win_get_cursor(0)

  -- Search downward for the first semicolon
  local found_down = vim.fn.search(";", "cnW")

  -- If not found, move cursor back to original position and search upward
  if found_down == 0 then
    vim.api.nvim_win_set_cursor(0, curpos)
    vim.cmd("normal! v") -- Start visual mode from current position
    vim.fn.search(";", "bcnW")
  else
    vim.cmd("normal! v") -- Start visual mode from current position
    vim.fn.search(";", "cnW")
  end
end

function M.ExportQueryToCSV()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local start_line = start_pos[2]
  local start_col = start_pos[3]
  local end_line = end_pos[2]
  local end_col = end_pos[3]
  local lines = vim.fn.getline(start_line, end_line)
  lines[1] = string.sub(lines[1], start_col)
  lines[#lines] = string.sub(lines[#lines], 1, end_col)
  local query = table.concat(lines, " ")
  local filepath = vim.fn.input("Enter CSV file path: ")
  query = string.gsub(query, ";%s*$", "")
  local copy_query = string.format("\\copy (%s) TO '%s' CSV HEADER;", query, filepath)
  vim.cmd("DB " .. copy_query)
end

function M.DadbodCompletion()
  local items = vim.fn["dadbod::completion::GetCompletionItems"]()

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

vim.api.nvim_create_user_command("RunPythonScript", function()
  local current_file = vim.fn.expand("%:p")
  local escaped_file = vim.fn.fnameescape(current_file)

  -- Save the current buffer
  vim.cmd("write")

  -- Create a new terminal window if none was found
  vim.cmd("split | terminal")
  vim.cmd("startinsert")
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("python " .. escaped_file .. "<CR>", true, false, true),
    "t",
    true
  )
  -- Mark this terminal buffer for future identification
  local new_term_buf = vim.api.nvim_get_current_buf()
  vim.b[new_term_buf].is_python_terminal = true
end, {})

vim.api.nvim_create_user_command("RunShellScript", function()
  local current_file = vim.fn.expand("%:p")
  local escaped_file = vim.fn.fnameescape(current_file)

  -- Save the current buffer
  vim.cmd("write")

  -- Create a new terminal window if none was found
  vim.cmd("split | terminal")
  vim.cmd("startinsert")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("./" .. escaped_file .. "<CR>", true, false, true), "t", true)
  -- Mark this terminal buffer for future identification
  local new_term_buf = vim.api.nvim_get_current_buf()
  vim.b[new_term_buf].is_shell_terminal = true
end, {})

return M
