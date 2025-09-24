local notifications = require('utils.notifications')

local PyenvHelper = {}
function PyenvHelper.get_pyenv_version()
    local cwd_handle = io.popen("pwd")
    local cwd = cwd_handle:read("*a")
    cwd_handle:close()
    cwd = cwd:gsub("%s+$", "")
    local handle = io.popen("pyenv version-name")
    if handle then
      local result = handle:read("*a")
      handle:close()
      result = result:gsub("%s+$", "")
      notifications.sendNotification(result, vim.log.levels.INFO)
      if result ~= "" then
        local home_dir = os.getenv("HOME")
        local pyenv_python = home_dir .. "/.pyenv/versions/" .. result .. "/bin/python"
        Utils.sendNotification(pyenv_python, vim.log.levels.INFO)
        return pyenv_python
      end
    end
end

return PyenvHelper
