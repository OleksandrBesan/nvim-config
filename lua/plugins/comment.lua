return {
    'numToStr/Comment.nvim',
    opts = {
        ---Add a space between comment and the line
        padding = true,
        ---Whether the cursor should stay at its position
        sticky = true,
        ---Lines to be ignored while (un)comment
        ignore = nil,
        ---Key mappings
        toggler = {
            ---Line-comment toggle keymap
            line = 'gcc',
            ---Block-comment toggle keymap
            block = 'gbc',
        },
        ---Operator-pending mappings
        opleader = {
            ---Line-comment keymap
            line = 'gc',
            ---Block-comment keymap
            block = 'gb',
        },
        ---Extra mappings
        extra = {
            above = 'gcO',
            below = 'gco',
            eol = 'gcA',
        },
        ---Enable keybindings
        mappings = {
            basic = true,
            extra = true,
        },
        ---Hook for Treesitter integration or custom logic
        pre_hook = function(ctx)
            -- Use ts_context_commentstring for Treesitter-based languages
            if vim.bo.filetype == 'typescriptreact' or vim.bo.filetype == 'javascriptreact' then
                return require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()(ctx)
            end
        end,
        post_hook = nil,
        ---Filetype-specific comments
        ft = {
            sql = { '--%s', '/** %s */' },
            python = { '#%s', '"""%s"""' },
            rust = { '//%s', '/*%s*/' },
            java = { '//%s', '/*%s*/' },
            javascript = { '//%s', '/*%s*/' },
            lua = '#%s',
            sh = '#%s',
            toml = '#%s',
            graphql = '#%s',
            yaml = '#%s',
        },
    }
}
