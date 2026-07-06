return {
  'akinsho/bufferline.nvim',
  version = '*',
  lazy = true,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = { 'VeryLazy' },
  config = function()
    require('bufferline').setup({
      options = {
        mode = 'buffers',
        numbers = 'none',
        indicator = nil,
        buffer_close_icon = '',
        modified_icon = '',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 14,
        max_prefix_length = 8,
        tab_size = 12,
        diagnostics = false,
        color_icons = false,
        show_buffer_icons = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        show_tab_indicators = false,
        show_duplicate_prefix = true,
        persist_buffer_sort = true,
        move_wraps = true,
        separator_style = { '', '' },
        always_show_bufferline = false,
        sort_by = 'insert_at_end',
        custom_filter = function(buf_number)
          if vim.bo[buf_number].filetype == 'alpha' then
            return false
          end
          local buftype = vim.bo[buf_number].buftype
          if buftype == 'help' or buftype == 'quickfix' or buftype == 'terminal' then
            return false
          end
          return true
        end,
        hover = {
          enabled = true,
          delay = 200,
          reveal = { 'close' },
        },
      },
      highlights = {
        fill = {
          bg = '#0e0e0e',
        },
        background = {
          bg = '#0e0e0e',
        },
        tab = {
          bg = '#0e0e0e',
        },
        tab_selected = {
          bg = '#0e0e0e',
        },
        buffer = {
          bg = '#0e0e0e',
          fg = '#5a5a5a',
        },
        buffer_visible = {
          bg = '#0e0e0e',
          fg = '#777777',
        },
        buffer_selected = {
          bg = '#0e0e0e',
          fg = '#d4d4d4',
          bold = true,
        },
        separator = {
          bg = '#0e0e0e',
        },
        separator_selected = {
          bg = '#0e0e0e',
        },
        separator_visible = {
          bg = '#0e0e0e',
        },
        modified = {
          fg = '#5a5a5a',
        },
        modified_visible = {
          fg = '#777777',
        },
        modified_selected = {
          fg = '#e5c07b',
        },
        duplicate_selected = {
          fg = '#d4d4d4',
        },
        duplicate_visible = {
          fg = '#777777',
        },
        duplicate = {
          fg = '#5a5a5a',
        },
      },
    })
  end,
}
