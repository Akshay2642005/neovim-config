-- Trouble as a flat diagnostics list (no tree UI).
-- `indent_guides` is what draws the tree-like nesting lines; `multiline`
-- keeps every message on one quickfix-style row. Fold actions are unbound
-- so nothing can nest visually (diagnostics are flat items anyway).
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
  },
  opts = {
    indent_guides = false,
    multiline = false,
    max_items = 200,
    focus = false,
    win = { position = 'bottom', size = 10 },
    keys = {
      zo = false,
      zO = false,
      zc = false,
      zC = false,
      za = false,
      zA = false,
      zm = false,
      zM = false,
      zr = false,
      zR = false,
      zx = false,
      zX = false,
      zn = false,
      zN = false,
      zi = false,
    },
  },
}
