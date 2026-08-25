return {
  'nvim-treesitter/nvim-treesitter',
  event = { 'BufReadPost', 'BufNewFile' },
  cmd = {
    'TSInstall',
    'TSInstallAll',
    'TSUpdate',
    'TSUpdateSync',
    'TSBufEnable',
    'TSBufDisable',
    'TSModuleInfo',
  },
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter-textobjects',
      config = function()
        require('nvim-treesitter-textobjects').setup({
          select = { lookahead = true },
          move = { set_jumps = true },
        })

        local select = require('nvim-treesitter-textobjects.select').select_textobject
        local move = require('nvim-treesitter-textobjects.move')

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
        end

        -- Select textobjects
        map({ 'x', 'o' }, 'af', function() select('@function.outer', 'textobjects') end, 'Function (around)')
        map({ 'x', 'o' }, 'if', function() select('@function.inner', 'textobjects') end, 'Function (inner)')
        map({ 'x', 'o' }, 'ac', function() select('@class.outer', 'textobjects') end, 'Class (around)')
        map({ 'x', 'o' }, 'ic', function() select('@class.inner', 'textobjects') end, 'Class (inner)')
        map({ 'x', 'o' }, 'aa', function() select('@parameter.outer', 'textobjects') end, 'Parameter (around)')
        map({ 'x', 'o' }, 'ia', function() select('@parameter.inner', 'textobjects') end, 'Parameter (inner)')
        map({ 'x', 'o' }, 'ab', function() select('@block.outer', 'textobjects') end, 'Block (around)')
        map({ 'x', 'o' }, 'ib', function() select('@block.inner', 'textobjects') end, 'Block (inner)')

        -- Move to next/previous
        map({ 'n', 'x', 'o' }, ']f', function() move.goto_next_start({ '@function.outer' }, 'textobjects') end, 'Next function start')
        map({ 'n', 'x', 'o' }, ']F', function() move.goto_next_end({ '@function.outer' }, 'textobjects') end, 'Next function end')
        map({ 'n', 'x', 'o' }, '[f', function() move.goto_previous_start({ '@function.outer' }, 'textobjects') end, 'Prev function start')
        map({ 'n', 'x', 'o' }, '[F', function() move.goto_previous_end({ '@function.outer' }, 'textobjects') end, 'Prev function end')
        map({ 'n', 'x', 'o' }, ']c', function() move.goto_next_start({ '@class.outer' }, 'textobjects') end, 'Next class start')
        map({ 'n', 'x', 'o' }, '[c', function() move.goto_previous_start({ '@class.outer' }, 'textobjects') end, 'Prev class start')

        -- Swap parameters
        local swap = require('nvim-treesitter-textobjects.swap')
        map('n', '<leader>xp', function() swap.swap_next({ '@parameter.inner' }, 'textobjects') end, 'Swap param forward')
        map('n', '<leader>xP', function() swap.swap_previous({ '@parameter.inner' }, 'textobjects') end, 'Swap param backward')
      end,
    },
  },
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    vim.treesitter.language.register('json', 'jsonc')
    local config_parsers = require 'configs.treesitter.parsers'
    local parsers = config_parsers.install_automatically()

    vim.api.nvim_create_user_command('TSInstallAll', function()
      require('nvim-treesitter').install(parsers, { max_jobs = 1 })
    end, {})

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup(
        'start_treesitter',
        { clear = true }
      ),
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(ev.match)
        if lang == nil then
          return
        end
        if vim.treesitter.query.get(lang, 'highlights') ~= nil then
          vim.treesitter.start(ev.buf, lang)
        end
        if vim.treesitter.query.get(lang, 'folds') ~= nil then
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo.foldmethod = 'expr'
        end
        if vim.treesitter.query.get(lang, 'indents') ~= nil then
          vim.bo.indentexpr =
          'v:lua.require\'nvim-treesitter\'.indentexpr()'
        end
      end,
    })
  end,
}
