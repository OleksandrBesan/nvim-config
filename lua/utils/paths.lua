local M = {}

local notifications = require("utils.notifications")

function M.copy_paths(type)
  local file_path = vim.fn.expand('%:p')
  local relative_path = vim.fn.expand('%:.')
  local workflow_path = vim.fn.getcwd()

  if type == 'full' then
    vim.fn.setreg('+', file_path)
    notifications.sendNotification('Copied full path: ' .. file_path, vim.log.levels.INFO)
  elseif type == 'relative' then
    vim.fn.setreg('+', relative_path)
    notifications.sendNotification('Copied relative path: ' .. relative_path, vim.log.levels.INFO)
  elseif type == 'workflow' then
    vim.fn.setreg('+', workflow_path)
    notifications.sendNotification('Copied workflow path: ' .. workflow_path, vim.log.levels.INFO)
  end
end

return M
