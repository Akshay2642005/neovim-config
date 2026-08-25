-- Linting via nvim-lint; linters chosen to match mason-installed tools
-- (see configs/mason/packages.lua). Missing binaries are skipped silently.
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'

    -- only lint JS/TS when the project actually has an eslint config,
    -- otherwise eslint_d spams "no configuration found" diagnostics
    local function eslint_if_configured()
      local root = vim.fs.root(0, {
        'eslint.config.js',
        'eslint.config.mjs',
        'eslint.config.cjs',
        '.eslintrc',
        '.eslintrc.js',
        '.eslintrc.json',
        '.eslintrc.yml',
        '.eslintrc.yaml',
      })
      return root and { 'eslint_d' } or {}
    end

    lint.linters_by_ft = {
      go = { 'golangcilint' },
      python = { 'ruff' },
      sh = { 'shellcheck' },
      javascript = eslint_if_configured,
      javascriptreact = eslint_if_configured,
      typescript = eslint_if_configured,
      typescriptreact = eslint_if_configured,
    }

    -- run only linters whose binaries are actually installed so buffers stay
    -- quiet on machines where some tools haven't been mason-installed yet
    local function try_lint()
      local configured = lint.linters_by_ft[vim.bo.filetype]
      if not configured then return end
      if type(configured) == 'function' then configured = configured() end

      local names = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        return linter and linter.cmd and vim.fn.executable(linter.cmd) == 1
      end, configured or {})

      if #names > 0 then
        lint.try_lint(names)
      end
    end

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('nvim_lint', { clear = true }),
      callback = try_lint,
    })
  end,
}
