return {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
        vim.api.nvim_set_hl(0, 'GitSignsAdd', { link = 'GitSignsAdd' })
        vim.api.nvim_set_hl(0, 'GitSignsChange', { link = 'GitSignsChange' })
        vim.api.nvim_set_hl(0, 'GitSignsDelete', { link = 'GitSignsDelete' })
        vim.api.nvim_set_hl(0, 'GitSignsTopdelete', { link = 'GitSignsDelete' })
        vim.api.nvim_set_hl(0, 'GitSignsChangedelete', { link = 'GitSignsChange' })

        local is_git_repo = vim.fn.isdirectory(".git") ~= 0
        if is_git_repo then
            require("gitsigns").setup({
              -- Configuration options here
            })
        end
    end
}