-- Linting via nvim-lint; linters chosen to match mason-installed tools
-- (see configs/mason/packages.lua). Missing binaries are skipped silently.
return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'

    -- golangci-lint v2: silence transient non-zero exits (notably exit 3
    -- "parallel golangci-lint is running" from overlapping BufWritePost /
    -- InsertLeave triggers) and allow parallel runners. Diagnostics still
    -- publish from successful runs.
    local golangcilint = lint.linters.golangcilint
    if type(golangcilint) == 'function' then
      local ok, res = pcall(golangcilint)
      if ok then
        golangcilint = res
      end
    end
    if type(golangcilint) == 'table' then
      golangcilint.ignore_exitcode = true
      local golang_args = golangcilint.args
      local has_parallel = function(args)
        return vim.list_contains(args, '--allow-parallel-runners')
      end
      if type(golang_args) == 'table' and not has_parallel(golang_args) then
        table.insert(golang_args, 2, '--allow-parallel-runners')
      elseif type(golang_args) == 'function' then
        local orig_args = golang_args
        golangcilint.args = function(...)
          local resolved = orig_args(...)
          if type(resolved) == 'table' and not has_parallel(resolved) then
            table.insert(resolved, 2, '--allow-parallel-runners')
          end
          return resolved
        end
      end
    end

    local eslint_config_files = {
      'eslint.config.js',
      'eslint.config.mjs',
      'eslint.config.cjs',
      'eslint.config.ts',
      'eslint.config.mts',
      'eslint.config.cts',
      '.eslintrc',
      '.eslintrc.js',
      '.eslintrc.cjs',
      '.eslintrc.json',
      '.eslintrc.yml',
      '.eslintrc.yaml',
    }

    local function get_eslint_root(bufnr)
      return vim.fs.root(bufnr or 0, eslint_config_files)
    end

    -- only lint JS/TS when the project actually has an eslint config,
    -- otherwise eslint_d spams "no configuration found" diagnostics
    local function eslint_if_configured(bufnr)
      return get_eslint_root(bufnr) and { 'eslint_d' } or {}
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
    local function is_installed(name)
      local linter = lint.linters[name]
      if type(linter) == 'function' then
        local ok, res = pcall(linter)
        linter = ok and res or nil
      end
      if not linter or type(linter) ~= 'table' then
        return false
      end
      local cmd = linter.cmd
      if type(cmd) == 'function' then
        local ok, res = pcall(cmd)
        cmd = ok and res or nil
      end
      return type(cmd) == 'string' and vim.fn.executable(cmd) == 1
    end

    local function try_lint(ev)
      local bufnr = ev and ev.buf or 0
      local configured = lint.linters_by_ft[vim.bo[bufnr].filetype]
      if not configured then return end
      if type(configured) == 'function' then configured = configured(bufnr) end

      local names = vim.tbl_filter(is_installed, configured or {})

      if #names > 0 then
        local opts = {}
        if vim.list_contains(names, 'eslint_d') then
          local root = get_eslint_root(bufnr)
          if root then
            opts.cwd = root
          end
        end
        lint.try_lint(names, opts)
      end
    end

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('nvim_lint', { clear = true }),
      callback = try_lint,
    })
  end,
}
