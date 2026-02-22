local M = {}

local progress = {}

vim.api.nvim_create_autocmd('LspProgress', {
  desc = 'Update LSP progress in statusline',
  callback = function(args)
    if not args.data or not args.data.client_id then return end

    local v = args.data.params.value
    progress = {
      client = vim.lsp.get_client_by_id(args.data.client_id),
      kind = v.kind,
      title = v.title,
      message = v.message,
      percentage = v.percentage,
    }

    vim.cmd.redrawstatus()

    if v.kind == 'end' then
      vim.defer_fn(function()
        progress = {}
        vim.cmd.redrawstatus()
      end, 500)
    end
  end,
})

function M.component()
  if vim.o.columns < 120 then return '' end
  if not progress.title then return '' end

  local msg = progress.title
  if progress.message then msg = msg .. ' ' .. progress.message end
  if progress.percentage then msg = msg .. ' ' .. progress.percentage .. '%' end

  return string.format('%%#StatusLineLspMessages#%s%%* ', msg)
end

return M
