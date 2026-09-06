return {
  'kawre/leetcode.nvim',
  cmd = {
    'Leet',
  },
  dependencies = {
    -- include a picker of your choice, see picker section for more details
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
  opts = {
    -- configuration goes here
    lang = 'cpp',
    picker = { provider = 'snacks-picker' },
  },
  -- `nvim leetcode.nvim` boots straight into Leet using the plugin's
  -- OWN VimEnter handling (start(true): replaces the arg buffer itself
  -- in standalone mode). That handler only exists after setup() runs, so
  -- cmd-lazy loading would leave it dead -- hence this conditional load:
  -- with the arg present the plugin loads pre-VimEnter, otherwise it stays
  -- lazy on :Leet. (A previous attempt called :Leet from our own VimEnter
  -- hook instead; the plugin's non-VimEnter guard rejects that because a
  -- fresh empty buffer still counts as listed.)
  init = function()
    local args = vim.fn.argv()
    if #args == 1 and (args[1] == 'leetcode' or args[1] == 'leetcode.nvim') then
      require('lazy').load({ plugins = { 'leetcode.nvim' } })
    end
  end,
}