local PyenvHelper = require('pyenv')
local Utils = require('utils')
local lspconfig = require("lspconfig")
local M = {}

function M.setup()
    local pyenv_python = PyenvHelper.get_pyenv_version()
    local project_path = vim.fn.getcwd()
    local flake_config_files = {"setup.cfg", ".flake8", "tox.ini"}

    if not pyenv_python then
        Utils.sendNotification("Failed to retrieve Pyenv version", vim.log.levels.ERROR)
        return
    else
      Utils.sendNotification(pyenv_python, vim.log.levels.INFO)
    end
    -- ALE 
  --
    vim.g.ale_python_python_executable = pyenv_python
    vim.g.ale_python_flake8_executable = pyenv_python
    vim.g.ale_python_mypy_executable = pyenv_python
    vim.g.ale_python_flake8_use_global=1
    vim.g.ale_python_mypy_use_global=1
    vim.opt.keywordprg = pyenv_python .. " -m pydoc"
    for _, config_file in ipairs(flake_config_files) do
        local config_path = project_path .. "/" .. config_file
        if vim.fn.filereadable(config_path) == 1 then
            -- Set ALE's flake8 options to use the found config file
            vim.g.ale_python_flake8_options = "-m flake8 --ignore=T4 --config=" .. config_path
            break  -- Exit the loop after finding the first valid config file
        end
    end
    lspconfig.pyright.setup({
      cmd = {"pyright-langserver", "--stdio"},
      on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
       end,
      settings = {
        python = {
          pythonPath = pyenv_python,
          analysis = {
                typeCheckingMode = "off",
                reportGeneralTypeIssues = false,
                reportMissingImports = false
          }
        }
      }
    })

  vim.cmd('command! PyenvSetup lua require("lsp_python_setup").setup()')
  vim.cmd("autocmd DirChanged * PyenvSetup")
end

return M
