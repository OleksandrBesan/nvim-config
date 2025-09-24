local M = {}

local notifications = require("utils.notifications")

local uv = vim.uv or vim.loop

local function path_join(a, b)
  if a:sub(-1) == "/" then return a .. b end
  return a .. "/" .. b
end

local function readable(p)
  local s = uv.fs_stat(p)
  return s and s.type == "file"
end

local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end

local function unquote(v)
  v = trim(v)
  if (v:sub(1,1) == '"' and v:sub(-1) == '"') or (v:sub(1,1) == "'" and v:sub(-1) == "'") then
    v = v:sub(2, -2)
  end
  -- basic escapes
  v = v:gsub("\\n", "\n"):gsub("\\t", "\t"):gsub("\\r", "\r")
  return v
end

local function git_root()
  local ok, result = pcall(function()
    local out = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait()
    if out and out.code == 0 and out.stdout then
      return trim(out.stdout)
    end
  end)
  return ok and result or nil
end

local function candidate_paths()
  local uv = vim.uv or vim.loop
  local cfg  = vim.fn.stdpath("config")
  local cwd  = uv.cwd()
  local root = (function()
    local ok, out = pcall(function()
      local r = vim.system({ "git", "rev-parse", "--show-toplevel" }, { text = true }):wait()
      return (r and r.code == 0) and (r.stdout:gsub("%%s+$", "")) or nil
    end)
    return ok and out or nil
  end)()
  local home = uv.os_homedir()

  local paths = {}
  local function add(dir, file) if dir then table.insert(paths, (dir:sub(-1) == "/" and dir or (dir .. "/")) .. file) end end

  -- Put your config FIRST so it wins
  for _, dir in ipairs({ cfg, cwd, root, home }) do
    add(dir, ".env.local")
    add(dir, ".env")
  end
  return paths
end

local function parse_line(line)
  -- strip comments (allow inline # only if quoted)
  if line:match("^%s*#") then return nil end
  -- handle BOM
  line = line:gsub("^\\239\\187\\191", "")
  local eq = line:find("=")
  if not eq then return nil end

  local key = trim(line:sub(1, eq - 1))
  local val = trim(line:sub(eq + 1))

  -- support 'export FOO=bar'
  key = key:gsub("^export%%s+", "")

  if key == "" then return nil end
  -- keep inline comments only if value is quoted
  if not (val:sub(1,1) == '"' or val:sub(1,1) == "'") then
    -- remove trailing comment
    local hash = val:find("%%s#")
    if hash then val = trim(val:sub(1, hash - 1)) end
  end
  val = unquote(val)
  return key, val
end

function M.load_env_file(opts)
  opts = opts or {}
  local vars = {}
  local loaded_from

  for _, p in ipairs(candidate_paths()) do
    local f = io.open(p, "r")
    if f then
      for line in f:lines() do
        local k, v = parse_line(line)
        if k then
          vars[k] = v
          vim.env[k] = v
          vim.fn.setenv(k, v)
          vim.g["ENV_" .. k] = v
        end
      end
      f:close()
      if next(vars) then
        loaded_from = p
        break -- <- stop once we got at least one key
      end
    end
  end

  if opts.debug then
    if loaded_from then
      notifications.sendNotification(("ENV loaded from: %s (%%d keys)"):format(loaded_from, vim.tbl_count(vars)), vim.log.levels.INFO)
    else
      notifications.sendNotification("ENV: no keys found in any candidate .env", vim.log.levels.WARN)
    end
  end

  return vars
end

return M
