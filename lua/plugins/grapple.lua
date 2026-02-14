return {
  'cbochs/grapple.nvim',
  lazy = false,
  event = 'BufReadPost',
  config = function()
    local grapple = require('grapple')

    grapple.setup {
      scope = "git",
      quick_select = false,
      tag_title = function(scope)
        return vim.fn.fnamemodify(scope.id, ':t')
      end,
      styles = {
        custom = function(entity, _)
          local Path = require 'grapple.path'

          local parent_mark = {
            virt_text = {
              {
                Path.parent(Path.fs_short(entity.tag.path)),
                'GrappleHint',
              },
            },
            virt_text_pos = 'eol',
          }

          local line = {
            display = Path.base(entity.tag.path),
            marks = { parent_mark },
          }

          return line
        end,
      },
      style = 'custom',
      win_opts = {
        width = 50,
        height = 12,
        row = 0.3,
      },
    }

    local MAX_TAGS = 9

    local function trim_grapple()
      local tags = grapple.tags()
      if #tags <= MAX_TAGS then
        return
      end

      -- remove oldest first
      for i = 1, #tags - MAX_TAGS do
        grapple.untag({ path = tags[i].path })
      end
    end
    -- Autocmd to automatically add open buffers to grapple
    vim.api.nvim_create_autocmd('BufEnter', {
      group = vim.api.nvim_create_augroup('GrappleAutoTag', { clear = true }),
      callback = function(args)
        local bufnr = args.buf
        local buftype = vim.bo[bufnr].buftype
        local filetype = vim.bo[bufnr].filetype
        local path = vim.api.nvim_buf_get_name(bufnr)

        -- Skip special buffers, empty paths, and non-file buffers
        if buftype ~= '' then return end
        if path == '' then return end
        if not vim.uv.fs_stat(path) then return end

        -- Skip certain filetypes
        local ignored_filetypes = { 'gitcommit', 'gitrebase', 'oil' }
        if vim.tbl_contains(ignored_filetypes, filetype) then return end

        -- Tag the buffer if not already tagged
        if not grapple.exists { path = path } then
          grapple.tag { path = path }
          trim_grapple()
        end
      end,
    })
  end,
}
