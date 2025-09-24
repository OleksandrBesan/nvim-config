local M = {}

if vim.loop.os_uname().sysname == "Darwin" then
  local handle = io.popen("brew --prefix")
  if handle then
    local brew_prefix = handle:read("*a"):gsub("\n", "")
    handle:close()

    if brew_prefix and brew_prefix ~= "" then
      vim.env.CURL_DIR = brew_prefix .. "/opt/curl"
      vim.env.CURL_INCDIR = brew_prefix .. "/opt/curl/include"
      vim.env.CURL_LIBDIR = brew_prefix .. "/opt/curl/lib"
      vim.env.PKG_CONFIG_PATH = brew_prefix .. "/lib/pkgconfig"
      vim.env.LUA_PATH = brew_prefix .. "/share/lua/5.4/?.lua;" .. brew_prefix .. "/share/lua/5.4/?/init.lua;"
      vim.env.LUA_CPATH = brew_prefix .. "/lib/lua/5.4/?.so;"
    end
  end
end

local env = require("utils.env")
local notifications = require("utils.notifications")

local env_vars = env.load_env_file({ debug = false }) or {}
vim.api.nvim_create_autocmd("DirChanged", {
  callback = function()
    env_vars = env.load_env_file() or env_vars
  end,
})

M.api_key_openai    = env_vars.OPENAI_API_KEY    or vim.env.OPENAI_API_KEY
M.api_key_anthropic = env_vars.ANTHROPIC_API_KEY or vim.env.ANTHROPIC_API_KEY

if M.api_key_openai then
  notifications.sendNotification("OPENAI_API_KEY loaded", vim.log.levels.INFO)
else
  notifications.sendNotification("OPENAI_API_KEY is not set.", vim.log.levels.ERROR)
end

if M.api_key_anthropic then
  notifications.sendNotification("ANTHROPIC_API_KEY loaded", vim.log.levels.INFO)
else
  notifications.sendNotification("ANTHROPIC_API_KEY is not set.", vim.log.levels.ERROR)
end

return M
