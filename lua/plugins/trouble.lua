-- Trouble as a tree diagnostics list (Image 2 style).
-- `indent_guides` draws the tree-like nesting lines; `multiline`
-- keeps every message on one quickfix-style row. Folds are enabled
-- so filename groups can expand/collapse.
-- NOTE: <leader>dd / <leader>wd live here (not in core/keymaps/editor.lua)
-- so lazy.nvim's key handler owns them; defining them in both places
-- would shadow the Trouble toggle.
return {
  'folke/trouble.nvim',
  lazy = true,
  cmd = 'Trouble',
  keys = {
    {
      '<leader>wd',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Workspace diagnostics (Trouble)',
    },
    {
      '<leader>dd',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Buffer diagnostics (Trouble)',
    },
    {
      '<leader>xQ',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix list (Trouble)',
    },
    {
      '<leader>xL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location list (Trouble)',
    },
    {
      -- Provided by todo-comments.nvim (`Trouble todo ...` under the
      -- hood); inherits the tree opts above, so TODO/FIX/NOTE show with
      -- indent guides just like diagnostics.
      '<leader>xt',
      '<cmd>TodoTrouble<cr>',
      desc = 'TODOs / FIXMEs (Trouble)',
    },
  },
  opts = {
    indent_guides = true,
    multiline = false,
    max_items = 200,
    focus = true,
    auto_preview = false,
    win = { position = 'bottom', size = 10 },
    icons = {
      indent = {
        top = '│ ',
        middle = '├╴',
        last = '└╴',
        fold_open = ' ',
        fold_closed = ' ',
        ws = '  ',
      },
    },
    modes = {
      diagnostics = {
        groups = {
          { 'filename', format = '{file_icon} {basename:Title} {count}' },
        },
      },
    },
  },
}
