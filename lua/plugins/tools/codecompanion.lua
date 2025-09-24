local env = require("env")

return {
  "codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
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
              api_key = env.api_key_openai,
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
              api_key = env.api_key_openai,
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
              api_key = env.api_key_openai,
            },
          })
        end,
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            env = {
              api_key = env.api_key_anthropic,
            },
          })
        end,
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            -- MCP Tools
            make_tools = true, -- Make individual tools (@server__tool) and server groups (@server) from MCP servers
            show_server_tools_in_chat = true, -- Show individual tools in chat completion (when make_tools=true)
            add_mcp_prefix_to_tool_names = false, -- Add mcp__ prefix (e.g `@mcp__github`, `@mcp__neovim__list_issues`)
            show_result_in_chat = true, -- Show tool results directly in chat buffer
            format_tool = nil, -- function(tool_name:string, tool: CodeCompanion.Agent.Tool) : string Function to format tool names to show in the chat buffer
            -- MCP Resources
            make_vars = true, -- Convert MCP resources to #variables for prompts
            -- MCP Prompts
            make_slash_commands = true, -- Add MCP prompts as /slash commands
          },
        },
      },
    })
  end,
}
