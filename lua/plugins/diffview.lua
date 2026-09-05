-- PR-style side-by-side diffs + file history (Source Control parity).
-- NOTE: <leader>gd stays Snacks' quick git-diff picker; capital-D opens
-- the full Diffview layout so the two don't fight.
return {
  'sindrets/diffview.nvim',
  lazy = true,
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
  keys = {
    {
      '<leader>gD',
      '<cmd>DiffviewOpen<cr>',
      desc = 'Diffview: open working-tree diff',
    },
    {
      '<leader>gh',
      '<cmd>DiffviewFileHistory %<cr>',
      desc = 'Diffview: file history (current file)',
    },
    {
      '<leader>gH',
      '<cmd>DiffviewFileHistory<cr>',
      desc = 'Diffview: repo history',
    },
    {
      -- The only way out: closes the Diffview tabpage and restores
      -- the previous layout. No window-closing gymnastics needed.
      '<leader>gC',
      '<cmd>DiffviewClose<cr>',
      desc = 'Diffview: close',
    },
  },
  opts = {
    enhanced_diff_hl = true,
    view = { merge_tool = { layout = 'diff3_mixed' } },
  },
  config = function(_, opts)
    require('diffview').setup(opts)
    -- `q` closes from the file/history panels (the bottom list in your
    -- screenshot). Scoped to Diffview's own panel filetypes so `q` in
    -- the actual diff buffers keeps its normal meaning.
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('diffview_close_key', { clear = true }),
      pattern = { 'DiffviewFiles', 'DiffviewFileHistory' },
      callback = function(args)
        vim.keymap.set('n', 'q', '<cmd>DiffviewClose<cr>', {
          buffer = args.buf,
          silent = true,
          desc = 'Close Diffview',
        })
      end,
    })
  end,
}
