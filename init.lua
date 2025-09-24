vim.g.mapleader = " "
vim.g.maplocalleader = ";"
vim.opt.termguicolors = true
require("config.lazy")

local cmp = require("cmp")
vim.env.CURL_DIR = "/opt/homebrew/opt/curl"
vim.env.CURL_INCDIR = "/opt/homebrew/opt/curl/include"
vim.env.CURL_LIBDIR = "/opt/homebrew/opt/curl/lib"
vim.env.PKG_CONFIG_PATH = "/opt/homebrew/lib/pkgconfig"
vim.env.LUA_PATH = "/opt/homebrew/share/lua/5.4/?.lua;/opt/homebrew/share/lua/5.4/?/init.lua;"
vim.env.LUA_CPATH = "/opt/homebrew/lib/lua/5.4/?.so;"

function SelectToFirstSemicolon()
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

function ExportQueryToCSV()
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

vim.g.autoformat = false -- global autoformat enabled

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

vim.api.nvim_exec(
  [[
autocmd FileType sql lua vim.diagnostic.disable(0)
]],
  false
)
vim.o.switchbuf = "useopen,usetab"

vim.o.background = "dark"
vim.cmd("colorscheme everforest")
local function setup_gitsigns()
  local is_git_repo = vim.fn.isdirectory(".git") ~= 0
  if is_git_repo then
    require("gitsigns").setup({
      -- Configuration options here
    })
  end
end

setup_gitsigns()

vim.api.nvim_command("set conceallevel=0")




local Utils = require("utils")

local env_vars = Utils.load_env_file({ debug = false }) or {}
vim.api.nvim_create_autocmd("DirChanged", {
  callback = function()
    env_vars = Utils.load_env_file() or env_vars
  end,
})

local api_key_openai    = env_vars.OPENAI_API_KEY    or vim.env.OPENAI_API_KEY
local api_key_anthropic = env_vars.ANTHROPIC_API_KEY or vim.env.ANTHROPIC_API_KEY

if api_key_openai then
  Utils.sendNotification("OPENAI_API_KEY loaded", vim.log.levels.INFO)
else
  Utils.sendNotification("OPENAI_API_KEY is not set.", vim.log.levels.ERROR)
end

if api_key_anthropic then
  Utils.sendNotification("ANTHROPIC_API_KEY loaded", vim.log.levels.INFO)
else
  Utils.sendNotification("ANTHROPIC_API_KEY is not set.", vim.log.levels.ERROR)
end
require("codecompanion").setup({
  prompt_library = {
    ["Test writing"] = {
      strategy = "chat",
      description = "prompt for generation tests",
      prompts = {
        {
          role = "system",
          content = [[This GPT is designed to help write Python tests that adhere to a specific set of guidelines using pytest.
          It generates pytest tests with a focus on clean and structured test cases.
          It follows the Arrange-Act-Assert pattern for large tests and incorporates comments when necessary to clearly define each phase of the test.
          The Object Mother pattern is employed, using a fixture mother to generate objects with default argument values to simplify test setup.
          Tests will strictly adhere to the following criteria:
          1. Always use pytest for python code.
          3. Use Arrange, Act, Assert comments if test is large and the phases are not obvious from newlines.
          4. Use the Object Mother pattern, using a fixture mother to generate objects with appropriate defaults for method arguments.
          5. Dont make fixtures for object mother, use fixture `mother`
          6. If you use mother method - show definition of this method
          7. Dont write Explanations, just write code
          8. Use `create_autospec` if you want to create mock
          9. Prefere Classic Test School over London Test School
          10. I need only code, don't explain it for me
          11. Donʼt  use `@pytest.mark.asyncio` it already configured  with auto mode
          12. Use Object Mother for creating objects only if object is complex

          This GPT generates tests with a strong emphasis on maintainability, readability, and correctness.]],
        },
        {
          role = "user",
          content = "Generate code based on ...",
        },
      },
    },
  },
  strategies = {
    chat = {
      adapter = "openai",
    },
    chat_advance = {
      adapter = "openai_advance",
    },
    inline = {
      adapter = "openai_mini",
    },
    agent = {
      adapter = "openai",
    },
  },
  adapters = {
    openai_mini = function()
      return require("codecompanion.adapters").extend("openai", {
        schema = {
          model = {
            default = "gpt-4o-mini",
          },
        },
        env = {
          api_key = api_key_openai,
        },
      })
    end,
    openai = function()
      return require("codecompanion.adapters").extend("openai", {
        schema = {
          model = {
            default = "chatgpt-4o-latest",
          },
        },
        env = {
          api_key = api_key_openai,
        },
      })
    end,
    openai_advance = function()
      return require("codecompanion.adapters").extend("openai", {
        schema = {
          model = {
            default = "o3-mini",
          },
        },
        env = {
          api_key = api_key_openai,
        },
      })
    end,
    anthropic = function()
      return require("codecompanion.adapters").extend("anthropic", {
        env = {
          api_key = api_key_anthropic,
        },
      })
    end,
  }, 
  extensions = {
    mcphub = {
      callback = "mcphub.extensions.codecompanion",
      opts = {
        -- MCP Tools 
        make_tools = true,              -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
        show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
        add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
        show_result_in_chat = true,      -- Show tool results directly in chat buffer
        format_tool = nil,               -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
        -- MCP Resources
        make_vars = true,                -- Convert MCP resources to #variables for prompts
        -- MCP Prompts 
        make_slash_commands = true,      -- Add MCP prompts as /slash commands
      }
    }
  }
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "lua-format" },
    json = { "jq" },
    xml = { "xmlformat" },
    yaml = { "yamlfmt" },
    html = { "htmlbeautifier", "djlint" },
    hcl = { "hcl" },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
    filter = function(buf)
      -- Exclude `.env` files
      local filename = vim.api.nvim_buf_get_name(buf)
      return not filename:match("%.env$")
    end,
  },
})
require("fidget").setup({
notification = {
  override_vim_notify = true,
},
})

vim.notify = require("fidget").notify
vim.defer_fn(function()
vim.notify = require("fidget").notify
end, 100)
require("noice").setup({
notify = {
  enabled = false, -- Disable Noice's override of vim.notify
},
})
require("extensions").setup()
require("telescope").setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden", -- Make ripgrep include hidden files
    },
  },
})

