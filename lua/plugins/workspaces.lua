local Utils = require('utils')


return {
    -- Other plugin configurations

    {'natecraddock/workspaces.nvim',
        config = function()
            require('workspaces').setup({
                hooks = {
                    open = { -- Actions to perform when a workspace is opened
                        function(workspace)
                              if workspace and workspace.name then
                                  Utils.sendNotification("Opened workspace: " .. workspace.name, vim.log.levels.INFO)
                              else
                                  Utils.sendNotification("Opened workspace, but the name is unavailable", vim.log.levels.INFO)
                              end
                              require("lsp_python_setup").setup()
                        end
                    },
                   
        close = {
          function(workspace)
            if workspace and workspace.name then
                Utils.sendNotification("Closed workspace: " .. workspace.name, vim.log.levels.INFO)
            else
                Utils.sendNotification("Closed workspace, but the name is unavailable", vim.log.levels.INFO)
            end
          end
    }
                },
                autosave = false,  -- Automatically save workspaces
                autoload = false,  -- Automatically load the last workspace
                session = {
                    options = {
                        'buffers', 'curdir', 'tabpages', 'winsize'
                    }
                }
            })
        end
    }
}
