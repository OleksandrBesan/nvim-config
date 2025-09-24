local M = {}

function M.sendNotification(msg, log_level)
  vim.notify(msg, log_level, {
    title = "Notification",
    timeout = 5000,
    icon = "info",
  })
end

return M
