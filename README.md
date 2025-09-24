# My Neovim Configuration

This is my personal Neovim configuration, based on LazyVim. It is tailored to my workflow and includes a set of plugins and custom keymaps that I find useful.

## Installation

1.  Clone this repository to `~/.config/nvim`:

    ```bash
    git clone https://github.com/your-username/your-repo.git ~/.config/nvim
    ```

2.  Start Neovim:

    ```bash
    nvim
    ```

    Lazy.nvim will automatically install all the plugins.

## Plugins

Here is a list of the plugins I use, grouped by category:

### UI

*   **[alpha-nvim](https://github.com/goolord/alpha-nvim):** A fast and fully programmable startup screen.
*   **[bufferline.nvim](https://github.com/akinsho/bufferline.nvim):** A snazzy bufferline for Neovim.
*   **[fidget.nvim](https://github.com/j-hui/fidget.nvim):** Standalone UI for `nvim-lsp` progress.
*   **[gruvbox](https://github.com/morhetz/gruvbox):** A retro groove color scheme for Vim.
*   **[mini.indentscope](https://github.com/echasnovski/mini.indentscope):** A plugin to visualize indentation levels.
*   **[noice.nvim](https://github.com/folke/noice.nvim):** A highly experimental plugin that completely replaces the Neovim UI.
*   **[themes](https://github.com/LazyVim/LazyVim/tree/main/lua/lazyvim/plugins/themes):** A collection of themes for LazyVim.

### Completion

*   **[copilot.lua](https://github.com/github/copilot.vim):** GitHub Copilot for Neovim.
*   **[nvim-cmp](https://github.com/hrsh7th/nvim-cmp):** A completion engine plugin for Neovim.

### Editing

*   **[auto-save.nvim](https://github.com/pocco81/auto-save.nvim):** Automatically save your work.
*   **[comment.nvim](https://github.com/numToStr/Comment.nvim):** A comment plugin for Neovim.
*   **[conform.nvim](https://github.com/stevearc/conform.nvim):** A formatting plugin for Neovim.
*   **[mini.bracketed](https://github.com/echasnovski/mini.bracketed):** A plugin to go forward/backward with square brackets.
*   **[mini.pairs](https://github.com/echasnovski/mini.pairs):** A plugin to automatically manage pairs (brackets, quotes, etc.).
*   **[mini.splitjoin](https://github.com/echasnovski/mini.splitjoin):** A plugin to split and join arguments.
*   **[mini.surround](https://github.com/echasnovski/mini.surround):** A plugin to add/delete/change surroundings.
*   **[nvim-recorder](https://github.com/chrisgrieser/nvim-recorder):** A macro recorder for Neovim.
*   **[ssr.nvim](https://github.com/cshuaimin/ssr.nvim):** A structural search and replace plugin for Neovim.
*   **[vim-visual-multi](https://github.com/mg979/vim-visual-multi):** A multiple cursors plugin for Vim/Neovim.

### Git

*   **[diffview.nvim](https://github.com/sindrets/diffview.nvim):** A single tabpage interface for easily cycling through diffs.
*   **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim):** Git integration for Neovim.

### LSP

*   **[ale](https://github.com/dense-analysis/ale):** Asynchronous Lint Engine.
*   **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig):** A collection of configurations for the built-in LSP client.

### Parsing

*   **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter):** Neovim Treesitter configurations and abstraction layer.

### Tools

*   **[codecompanion.nvim](https://github.com/Saecki/codecompanion.nvim):** A code companion for Neovim.
*   **[image.nvim](https://github.com/3rd/image.nvim):** An image viewer for Neovim.
*   **[luarocks.nvim](https://github.com/vhyrro/luarocks.nvim):** A Luarocks wrapper for Neovim.
*   **[markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim):** A markdown preview plugin for Neovim.
*   **[marks.nvim](https://github.com/chentau/marks.nvim):** A better mark plugin for Neovim.
*   **[mcphub.nvim](https://github.com/Saecki/mcphub.nvim):** A plugin to manage your MCP hub.
*   **[mini.files](https://github.com/echasnovski/mini.files):** A file explorer plugin.
*   **[nvim-windows-picker](https://github.com/s1n7ax/nvim-windows-picker):** A window picker for Neovim.
*   **[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim):** A highly extendable fuzzy finder over lists.
*   **[vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui):** A UI for vim-dadbod.
*   **[workspaces.nvim](https://github.com/Saecki/workspaces.nvim):** A workspace manager for Neovim.

## Keymaps

Here are some of the custom keymaps I use:

| Keymap | Description |
| --- | --- |
| `<leader>tt` | Open terminal in horizontal split |
| `<leader>tc` | Open terminal in current buffer |
| `<leader>tf` | Open floating terminal |
| `<leader>tl` | Reopen last floating terminal |
| `<leader>e` | Open file explorer |
| `<leader>/` | Live Grep with Args |
| `<leader>\` | Live Grep |
| `<leader><F2>` | LSP References |
| `<leader><F3>` | LSP Type Definitions |
| `<leader>fp` | Find Plugin File |
| `<leader>j` | Open json(fly) |
| `<leader>
` | Find Buffers |
| `gS` | Split arguments |
| `gJ` | Join arguments |
| `gd` | Go to definition |
| `K` | Hover |
| `<leader>rn` | Rename |
| `gr` | References |
| `<leader>pf` | Copy full path |
| `<leader>pr` | Copy relative path |
| `<leader>pw` | Copy workflow path |
| `<leader>mp` | Prepend text to selected lines |
| `<leader>md` | Delete symbols from selected lines |
| `<leader>me` | Insert text at first and last selected lines |