return {
  'Ramilito/kubectl.nvim',
  version = '2.*',
  cmd = { 'Kubectl', 'K', 'Kubens', 'Kubectx' },
  keys = {
    {
      '<leader>k',
      function()
        require('kubectl').toggle()
      end,
      desc = 'Toggle kubectl',
    },
  },
  dependencies = { 'Saghen/blink.lib' },
  config = function()
    require('kubectl').setup()

    local layout = require 'kubectl.actions.layout'
    local original_float_framed_windows = layout.float_framed_windows

    layout.float_framed_windows = function(bufs, opts)
      local pane_name = vim.api.nvim_buf_get_name(bufs.pane_bufs[1])
      if #opts.panes ~= 1 or not pane_name:match 'kubectl://pods_pane_1$' then
        return original_float_framed_windows(bufs, opts)
      end

      local current_win = vim.api.nvim_get_current_win()
      if vim.api.nvim_win_get_config(current_win).relative ~= '' then
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          if vim.api.nvim_win_get_config(win).relative == '' then
            vim.api.nvim_set_current_win(win)
            break
          end
        end
      end

      vim.cmd 'botright split'
      local win = vim.api.nvim_get_current_win()
      vim.api.nvim_win_set_buf(win, bufs.pane_bufs[1])
      layout.set_win_options(win)

      return {
        hints_win = nil,
        pane_wins = { win },
        dimensions = {
          total_width = vim.api.nvim_win_get_width(win),
          total_height = vim.api.nvim_win_get_height(win),
          content_height = vim.api.nvim_win_get_height(win),
        },
      }
    end
  end,
}
