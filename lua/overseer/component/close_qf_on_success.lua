return {
  desc = 'Close the quickfix window after a delay when the task succeeds',
  params = {
    timeout = {
      type = 'number',
      desc = 'Delay in ms before closing the quickfix window',
      default = 2000,
      optional = true,
    },
  },
  constructor = function(params)
    local timeout = params.timeout or 2000
    return {
      on_complete = function(_, _, status)
        if status ~= 'SUCCESS' then
          return
        end
        vim.defer_fn(function()
          local qf_winid = vim.fn.getqflist({ winid = 0 }).winid
          if qf_winid ~= 0 then
            pcall(vim.api.nvim_win_close, qf_winid, false)
          end
        end, timeout)
      end,
    }
  end,
}
