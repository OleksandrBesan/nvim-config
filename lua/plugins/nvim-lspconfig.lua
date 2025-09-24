return {
    "neovim/nvim-lspconfig",
    dependencies = {
      'jose-elias-alvarez/nvim-lsp-ts-utils' ,  -- Existing requirement
      'kkharji/lspsaga.nvim',
      "hrsh7th/cmp-nvim-lsp"
    },
    config = function()
        local lspconfig = require("lspconfig")

        -- Helper function for on_attach
        local on_attach = function(client, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }

            -- Keymaps for LSP
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        end

        -- Rust LSP
        lspconfig.rust_analyzer.setup({
            on_attach = on_attach,
            settings = {
                ["rust-analyzer"] = {
                    assist = {
                        importGranularity = "module",
                        importPrefix = "by_self",
                    },
                    cargo = {
                        allFeatures = true,
                    },
                    procMacro = {
                        enable = true,
                    },
                },
            },
        })
        lspconfig.marksman.setup({
          on_attach = function(client, bufnr)
            -- Disable diagnostics for Marksman
        
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
        
            -- Optional: Set up key mappings and other configurations here
            -- if you still want to use other features from Marksman
            vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
          end,
        })
        vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
          local client = vim.lsp.get_client_by_id(ctx.client_id)
          if client.name == "marksman" then
            -- If Marksman, do not show diagnostics
            return
          else
            -- Otherwise, handle normally
            vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
          end
        end
        -- TypeScript and JavaScript LSP
        lspconfig.ts_ls.setup({
            on_attach = function(client, bufnr)
                -- Disable formatting, use a dedicated formatter
                client.server_capabilities.documentFormattingProvider = false
                on_attach(client, bufnr)
            end,
        })

        lspconfig.eslint.setup({
            on_attach = function(client, bufnr)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    command = "EslintFixAll",
                })
                on_attach(client, bufnr)
            end,
        })

        -- Java LSP
        lspconfig.jdtls.setup({
            cmd = { "jdtls" },
            root_dir = lspconfig.util.root_pattern(".git", "pom.xml", "build.gradle"),
            on_attach = on_attach,
        })

        -- Global capabilities for LSP
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        -- Additional servers can be added here
        local servers = { "rust_analyzer", "ts_ls", "eslint", "jdtls", "gopls" }
        for _, lsp in ipairs(servers) do
            lspconfig[lsp].setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
        end

        lspconfig.gopls.setup({
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                    },
                    staticcheck = true,
                },
            },
        })

        -- Additional LSP UI enhancements
        require("lspsaga").setup({})
    end,

}

