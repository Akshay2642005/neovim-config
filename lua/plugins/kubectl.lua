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
    require('kubectl').setup {
      log_level = vim.log.levels.INFO,
      auto_refresh = {
        enabled = true,
        interval = 300, -- milliseconds
      },
      diff = {
        bin = 'kubediff', -- or any other binary
      },
      kubectl_cmd = { cmd = 'kubectl', env = {}, args = {} },
      terminal_cmd = nil, -- Exec will launch in a terminal if set, i.e. "ghostty -e"
      namespace = 'All',
      namespace_fallback = {}, -- If you have limited access you can list all the namespaces here
      headers = {
        enabled = true,
        hints = true,
        context = true,
        heartbeat = true,
        blend = 20,
        skew = {
          enabled = true,
          log_level = vim.log.levels.OFF,
        },
      },
      lineage = {
        enabled = true, -- This feature is in beta at the moment
      },
      logs = {
        prefix = true,
        timestamps = true,
        since = '5m',
      },
      alias = {
        apply_on_select_from_history = true,
        max_history = 5,
      },
      filter = {
        apply_on_select_from_history = true,
        max_history = 10,
      },
      filter_label = {
        max_history = 20,
      },
      float_size = {
        width = 0.8,
        height = 0.5,

        -- Might need to tweak these to get it centered when float is smaller
        col = 10,
        row = 5,
      },
      statusline = {
        enabled = false,
      },
      obj_fresh = 5, -- highlight if creation newer than number (in minutes)
      api_resources_cache_ttl = 60 * 60 * 3, -- 3 hours in seconds
    }

    local layout = require 'kubectl.actions.layout'
    local original_float_framed_windows = layout.float_framed_windows

    layout.float_framed_windows = function(bufs, opts)
      local pane_name = vim.api.nvim_buf_get_name(bufs.pane_bufs[1])
      if #opts.panes ~= 1 or not pane_name:match 'kubectl://k8s_pods_pane_1$' then
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
