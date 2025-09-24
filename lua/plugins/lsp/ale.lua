return {
  "dense-analysis/ale",
  opt = true,
  cmd = { "ALEEnable", "ALEDisable", "ALEFix" },
  ft = { "python", "javascript", "typescript", "rust", "java" },
  config = function()
    vim.g.ale_linters = {
      python = { "flake8", "mypy" },
      javascript = {'eslint', 'jshint', 'standard'},
      typescript = {'eslint', 'tslint'},
      java = { "checkstyle", "pmd" },
      rust = {'rustc', 'rust-analyzer', 'clippy'},
      dockerfile = {'hadolint'},
      terraform = {'tflint'},
      yaml = {'yamllint'},
      toml = {'taplo'},
    }
    vim.g.ale_fixers = {
      python = {},
      javascript = { "eslint", "prettier" },
      typescript = { "eslint", "prettier" },
      rust = { "rustfmt" },
      java = { "google-java-format" },
    }
    vim.g.ale_linters_ignore = {
      sql = {"sqlfluff"}
    }
    vim.g.ale_fix_on_save = 0
    vim.g.ale_python_mypy_options = "-m mypy"
    vim.g.ale_use_neovim_diagnostics_api = 1
    vim.g.ale_completion_enabled = 1
    vim.g.ale_virtualtext_cursor = 1
    vim.g.ale_javascript_eslint_options = "--config .eslintrc.js"
    vim.g.ale_typescript_eslint_options = "--config .eslintrc.js"
    vim.g.ale_rust_clippy_options = "--message-format=json"
    vim.cmd([[
      autocmd BufWritePost,BufEnter *.py lua require('lint').try_lint()
      autocmd BufWritePost,BufEnter *.js lua require('lint').try_lint()
      autocmd BufWritePost,BufEnter *.ts lua require('lint').try_lint()
      autocmd BufWritePost,BufEnter *.rs lua require('lint').try_lint()
      autocmd BufWritePost,BufEnter *.java lua require('lint').try_lint()
      autocmd BufWritePost,BufEnter *.go lua require('lint').try_lint()
    ]])
  end,
}
