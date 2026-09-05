return {
  'stevearc/conform.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('conform').setup {
      notify_on_error = false,
      formatters = {
        shfmt = {
          args = { '-i', '2', '-filename', '$FILENAME' },
        },
        stylua = {
          args = { '--indent-type', 'Spaces', '--indent-width', '2', '-' },
        },
        prettier = {
          args = { '--tab-width', '2', '--stdin-filepath', '$FILENAME' },
        },
        prettierd = {
          args = { '--tab-width', '2', '$FILENAME' },
        },
        ['sql-formatter'] = {
          args = { '--indent', '2' },
        },
        ['clang-format'] = {
          -- args = {
          --   '--style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4, UseTab: Never, IndentCaseLabels: true, ColumnLimit: 0, AlignAfterOpenBracket: DontAlign, ContinuationIndentWidth: 4, BinPackParameters: false, BinPackArguments: false, AllowShortFunctionsOnASingleLine: Empty, AllowShortIfStatementsOnASingleLine: false, AllowShortLoopsOnASingleLine: false, PointerAlignment: Left, BreakBeforeBraces: Attach, SpaceBeforeAssignmentOperators: true, AccessModifierOffset: -4, NamespaceIndentation: All}',
          -- },
        },
        leptosfmt = {
          args = { '--stdin', '--rustfmt' },
          stdin = true,
        },
      },
      format_after_save = function(bufnr)
        if not vim.g.format_on_save then
          return
        end
        local ignore_filetypes = { 'sql', 'java' }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end
        return {
          lsp_format = 'fallback',
        }
      end,
      formatters_by_ft = {
        astro = { 'prettierd', 'prettier', stop_after_first = true },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        cs = { 'csharpier' },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        dart = { 'dartfmt' },
        elixir = { 'mix format' },
        gleam = { 'gleam' },
        go = { 'gofumpt', 'goimports' },
        haskell = { 'ormolu' },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        htmldjango = { 'djlint' },
        java = { 'google-java-format' },
        javascript = {
          'prettierd',
          'prettier',
          'biome',
          stop_after_first = true,
        },
        javascriptreact = {
          'prettierd',
          'prettier',
          'biome',
          stop_after_first = true,
        },
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
        rust = function(bufnr)
          local found = vim.fs.find('leptosfmt.toml', {
            upward = true,
            path = vim.api.nvim_buf_get_name(bufnr),
          })
          if #found > 0 then
            return { 'leptosfmt' }
          end
          return { 'rustfmt' }
        end,
        scss = { 'prettierd', 'prettier', stop_after_first = true },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        sql = { 'sql-formatter' },
        svelte = { 'prettierd', 'prettier', stop_after_first = true },
        template = { 'djlint' },
        toml = { 'taplo' },
        typescript = {
          'prettierd',
          'prettier',
          'biome',
          stop_after_first = true,
        },
        typescriptreact = {
          'prettierd',
          'prettier',
          'biome',
          stop_after_first = true,
        },
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
        local end_line =
          vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ['end'] = { args.line2, end_line:len() },
        }
      end
      require('conform').format {
        async = true,
        lsp_format = 'fallback',
        range = range,
      }
    end, { range = true, desc = 'Format buffer or range' })

    -- Keymap for manual formatting
    vim.keymap.set({ 'n', 'v' }, '<leader>fm', function()
      require('conform').format { async = true, lsp_format = 'fallback' }
    end, { desc = 'Format buffer' })
  end,
}
