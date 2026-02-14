return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local mason_bin = vim.fn.stdpath('data') .. '\\mason\\bin\\'

    local fmt_paths = {
      stylua = mason_bin .. 'stylua.CMD',
      shfmt = mason_bin .. 'shfmt.CMD',
      gofumpt = mason_bin .. 'gofumpt.CMD',
      goimports = mason_bin .. 'goimports.CMD',
      prettierd = mason_bin .. 'prettierd.CMD',
      ['php-cs-fixer'] = mason_bin .. 'php-cs-fixer.CMD',
      ['clang-format'] = mason_bin .. 'clang-format.CMD',
      prettier = mason_bin .. 'prettier.CMD',
      rustfmt = mason_bin .. 'rustfmt.CMD',
      ktlint = mason_bin .. 'ktlint.CMD',
      ruff = mason_bin .. 'ruff.CMD',
      buf = mason_bin .. 'buf.CMD',
      ['ast-grep'] = mason_bin .. 'ast-grep.CMD',
      asmfmt = mason_bin .. 'asmfmt.CMD',
      rubocop = mason_bin .. 'rubocop.CMD',
      biome = mason_bin .. 'biome.CMD',
      taplo = mason_bin .. 'taplo.CMD',
      yamlfmt = mason_bin .. 'yamlfmt.CMD',
      ['sql-formatter'] = mason_bin .. 'sql-formatter.CMD',
      djlint = mason_bin .. 'djlint.CMD',
      ['google-java-format'] = mason_bin .. 'google-java-format.CMD',
      csharpier = mason_bin .. 'csharpier.CMD',
      zigfmt = mason_bin .. 'zig.CMD',
      gleam = 'gleam',
      dartfmt = 'dart',
      ocamlformat = 'ocamlformat',
    }

    local formatter_config = {}
    for name, path in pairs(fmt_paths) do
      formatter_config[name] = {
        command = path,
      }
    end

    -- Configure formatters to use indent width of 2
    formatter_config.shfmt = {
      command = fmt_paths.shfmt,
      args = { '-i', '2', '-filename', '$FILENAME' },
    }

    formatter_config.stylua = {
      command = fmt_paths.stylua,
      args = { '--indent-type', 'Spaces', '--indent-width', '2', '-' },
    }

    formatter_config.prettier = {
      command = fmt_paths.prettier,
      args = { '--tab-width', '2', '--stdin-filepath', '$FILENAME' },
    }

    formatter_config.prettierd = {
      command = fmt_paths.prettierd,
      args = { '--tab-width', '2', '$FILENAME' },
    }

    formatter_config['sql-formatter'] = {
      command = fmt_paths['sql-formatter'],
      args = { '--indent', '2' },
    }

    formatter_config['clang-format'] = {
      command = fmt_paths['clang-format'],
      args = { '--style={IndentWidth: 2}' },
    }

    require('conform').setup {
      notify_on_error = false,
      formatters = formatter_config,
      format_after_save = function(bufnr)
        if not vim.g.format_on_save then
          return
        end
        local ignore_filetypes = { 'sql', 'java' }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end
        return {
          lsp_fallback = true,
        }
      end,
      formatters_by_ft = {
        astro = { 'prettierd', 'prettier', stop_after_first = true },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        cs = { 'csharpier' },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        dart = { 'dartfmt' },
        gleam = { 'gleam' },
        go = { 'gofumpt', 'goimports' },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        htmldjango = { 'djlint' },
        java = { 'google-java-format' },
        javascript = { 'prettierd', 'prettier', 'biome', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', 'biome', stop_after_first = true },
        json = { 'prettierd', 'prettier', 'biome', stop_after_first = true },
        jsonc = { 'prettierd', 'prettier', 'biome', stop_after_first = true },
        kotlin = { 'ktlint' },
        lua = { 'stylua' },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
        ocaml = { 'ocamlformat' },
        php = { 'php-cs-fixer' },
        proto = { 'buf' },
        python = { 'ruff' },
        ruby = { 'rubocop' },
        rust = { 'rustfmt' },
        scss = { 'prettierd', 'prettier', stop_after_first = true },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        sql = { 'sql-formatter' },
        svelte = { 'prettierd', 'prettier', stop_after_first = true },
        template = { 'djlint' },
        toml = { 'taplo' },
        typescript = { 'prettierd', 'prettier', 'biome', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', 'biome', stop_after_first = true },
        yaml = { 'yamlfmt' },
        zig = { 'zigfmt' },
      },
    }

    -- Enable format on save by default
    vim.g.format_on_save = true

    -- Toggle format on save command
    vim.api.nvim_create_user_command('FormatOnSaveToggle', function()
      vim.g.format_on_save = not vim.g.format_on_save
      if vim.g.format_on_save then
        vim.notify('Format on save enabled', vim.log.levels.INFO)
      else
        vim.notify('Format on save disabled', vim.log.levels.INFO)
      end
    end, { desc = 'Toggle format on save' })

    -- Manual format command
    vim.api.nvim_create_user_command('Format', function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ['end'] = { args.line2, end_line:len() },
        }
      end
      require('conform').format { async = true, lsp_fallback = true, range = range }
    end, { range = true, desc = 'Format buffer or range' })

    -- Keymap for manual formatting
    vim.keymap.set({ 'n', 'v' }, '<leader>fm', function()
      require('conform').format { async = true, lsp_fallback = true }
    end, { desc = 'Format buffer' })
  end,
}
