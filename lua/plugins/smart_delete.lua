local function get_trash_cmd()
  if vim.fn.has('mac') == 1 then return 'trash' end
  if vim.fn.has('linux') == 1 then return 'gio trash' end
  return nil
end

local function trash_file(path)
  local cmd = get_trash_cmd()
  if not cmd then
    vim.notify('trash not available — install `brew install trash` on macOS', vim.log.levels.ERROR)
    return false
  end

  local escaped = vim.fn.shellescape(path)
  local result = os.execute(cmd .. ' ' .. escaped)
  if result then
    vim.notify('Trashed: ' .. vim.fn.fnamemodify(path, ':t'))
    return true
  else
    vim.notify('Failed to trash: ' .. path, vim.log.levels.ERROR)
    return false
  end
end

local function trash_buffer()
  local buf = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buf)
  if name == '' then
    vim.notify('No file to trash', vim.log.levels.WARN)
    return
  end

  if not vim.fn.filereadable(name) == 1 then
    vim.notify('File not found: ' .. name, vim.log.levels.WARN)
    return
  end

  if trash_file(name) then
    vim.bo[buf].buflisted = false
    vim.cmd('bdelete ' .. buf)
  end
end

return {
  keys = {
    { '<leader>D', trash_buffer, desc = 'Trash current file' },
  },
  cmd = { 'Trash' },
  init = function()
    vim.api.nvim_create_user_command('Trash', function(opts)
      trash_file(opts.fargs[1])
    end, { nargs = 1, complete = 'file' })
  end,
}
