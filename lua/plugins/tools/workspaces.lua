local notifications = require('utils.notifications')


return {
    -- Other plugin configurations

    {'natecraddock/workspaces.nvim',
        config = function()
            require('workspaces').setup({
                hooks = {
                    open = { -- Actions to perform when a workspace is opened
                        function(workspace)
                              if workspace and workspace.name then
                                  notifications.sendNotification("Opened workspace: " .. workspace.name, vim.log.levels.INFO)
                              else
                                  notifications.sendNotification("Opened workspace, but the name is unavailable", vim.log.levels.INFO)
                              end
                              require("lsp_python_setup").setup()
                        end
                    },
                   
        close = {
          function(workspace)
            if workspace and workspace.name then
                notifications.sendNotification("Closed workspace: " .. workspace.name, vim.log.levels.INFO)
            else
                notifications.sendNotification("Closed workspace, but the name is unavailable", vim.log.levels.INFO)
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