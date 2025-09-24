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


return M
