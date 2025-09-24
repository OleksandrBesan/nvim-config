return {
  '0x00-ketsu/autosave.nvim',
  event = { "InsertLeave", "TextChanged" },
  config = function()
    local autosave = require('autosave')
    local fidget = require('fidget')
    local last_notify_time = 0
    local notify_interval = 5 -- seconds

    autosave.setup {
      enable = true,
      prompt = { enable = false }, -- Disable built-in prompt completely
      events = { 'InsertLeave', 'TextChanged' },
      conditions = {
        exists = true,
        modifiable = true,
        filename_is_not = {},
        filetype_is_not = {}
      },
      write_all_buffers = true,
      debounce_delay = 135,
    }

    -- Custom notification with Fidget
    autosave.hook_after_saving = function ()
      local current_time = os.time()
      if current_time - last_notify_time > notify_interval then
        last_notify_time = current_time
        fidget.notify(
          "Autosaved: " .. vim.fn.expand('%:t') .. " at " .. vim.fn.strftime('%H:%M:%S'),
          vim.log.levels.INFO
        )
      end
    end
  end
}
