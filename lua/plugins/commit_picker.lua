return {
  name = 'commit-picker',
  ft = 'gitcommit',
  config = function()
    local group = vim.api.nvim_create_augroup('commit_picker', { clear = true })

    local function pick_messages()
      local handle = io.popen('git log --oneline -50 --format="%s" 2>/dev/null')
      if not handle then return end
      local result = handle:read('*a')
      handle:close()

      local messages = {}
      for line in result:gmatch('[^\n]+') do
        if line ~= '' then
          messages[#messages + 1] = { text = line }
        end
      end

      if #messages == 0 then
        vim.notify('No commit messages found', vim.log.levels.INFO)
        return
      end

      Snacks.picker({
        items = messages,
        title = 'Commit Messages',
        layout = {
          layout = {
            preview = false,
            width = 0.5,
            height = 0.6,
          },
        },
        format = 'text',
        confirm = function(picker, item)
          picker:close()
          if not item then return end
          vim.api.nvim_buf_set_lines(0, 0, 1, false, { item.text })
        end,
      })
    end

    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      pattern = 'gitcommit',
      callback = function()
        vim.keymap.set('i', '<C-c>', pick_messages, { buffer = 0, desc = 'Pick commit message' })
        vim.keymap.set('n', '<C-c>', pick_messages, { buffer = 0, desc = 'Pick commit message' })
      end,
    })
  end,
}
