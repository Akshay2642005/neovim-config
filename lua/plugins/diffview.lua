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
  },
  opts = {
    enhanced_diff_hl = true,
    view = { merge_tool = { layout = 'diff3_mixed' } },
  },
}
