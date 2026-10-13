return {
  'gmr458/cold.nvim',
  lazy = false,
  priority = 1000,
  build = ':ColdCompile',
  config = function()
    require('cold').setup {
      transparent_background = false,
      -- options.lua sets vim.o.cursorline = true, but cold defaults this to
      -- false in our setup, which makes CursorLine's bg identical to Normal
      -- and silently drops the current-line highlight.
      cursorline = true,
      treesitter_context_bg = false,
      float_borderless = false,
    }
    vim.cmd.colorscheme 'cold'
  end,
}
