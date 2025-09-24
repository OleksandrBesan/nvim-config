local M = {}

function M.setup()
    vim.api.nvim_create_user_command("PrependSymbol", 
      function(opts)
        local symbol = opts.args
        -- Get the range of selected lines
        local start_line = vim.fn.getpos("'<")[2]
        local end_line = vim.fn.getpos("'>")[2]
        -- Iterate over the range and prepend the symbol
        for i = start_line, end_line do
          local line = vim.fn.getline(i)
          vim.fn.setline(i, symbol .. line)
        end
      end, { nargs = 1, range = true })
    vim.api.nvim_create_user_command("DeleteSymbols", 
      function(opts)
        local count = tonumber(opts.args) -- Convert the argument to a number
        if not count or count <= 0 then
          vim.notify("Invalid number of symbols to delete", vim.log.levels.ERROR)
          return
        end
        -- Get the range of selected lines
        local start_line = vim.fn.getpos("'<")[2]
        local end_line = vim.fn.getpos("'>")[2]
        -- Iterate over the range and remove the first `count` characters from each line
        for i = start_line, end_line do
          local line = vim.fn.getline(i)
          -- Remove the first `count` characters if the line is long enough
          vim.fn.setline(i, line:sub(count + 1))
        end
      end, { nargs = 1, range = true })
    vim.api.nvim_create_user_command("InsertAtEdges", 
      function(opts)
        local text = opts.args
        -- Get the range of selected lines
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")
        -- Get the lines
        local first_line = vim.fn.getline(start_line)
        local last_line = vim.fn.getline(end_line)
        -- Prepend text to the first line
        vim.fn.setline(start_line, text .. first_line)
        -- Append text to the last line
        vim.fn.setline(end_line, last_line .. text)
      end, { nargs = 1, range = true })
end

return M
