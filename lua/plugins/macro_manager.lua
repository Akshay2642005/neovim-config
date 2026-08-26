local STORE_PATH = vim.fn.stdpath('data') .. '/macro_store.json'

local function load_store()
  local f = io.open(STORE_PATH, 'r')
  if not f then return {} end
  local content = f:read('*a')
  f:close()
  if content == '' then return {} end
  local ok, data = pcall(vim.json.decode, content)
  return ok and data or {}
end

local function save_store(data)
  local f = io.open(STORE_PATH, 'w')
  if not f then return end
  f:write(vim.json.encode(data))
  f:close()
end

local function readable_macro(reg)
  local keys = vim.fn.getreg(reg)
  if keys == '' then return '(empty)' end
  return keys
    :gsub('\n', ' <CR> ')
    :gsub('\t', ' <TAB> ')
    :gsub('\x1b', '<ESC>')
    :gsub('\r', '<CR>')
end

local function picker_items(store)
  local items = {}
  for name, entry in pairs(store) do
    items[#items + 1] = {
      text = name,
      file = entry.register or 'q',
      text_alt = readable_macro(entry.content),
    }
  end
  table.sort(items, function(a, b) return a.text < b.text end)
  return items
end

return {
  'snacks.nvim',
  keys = {
    {
      '<leader>ms',
      function()
        local store = load_store()
        vim.ui.input({ prompt = 'Macro name: ' }, function(name)
          if not name or name == '' then return end
          local register = vim.fn.getreg('"')
          if register == '' then
            vim.notify('Register is empty', vim.log.levels.WARN)
            return
          end
          store[name] = { content = register, register = '"', saved_at = os.date('%Y-%m-%d %H:%M') }
          save_store(store)
          vim.notify('Macro "' .. name .. '" saved')
        end)
      end,
      desc = 'Save macro to store',
    },
    {
      '<leader>ml',
      function()
        local store = load_store()
        local items = picker_items(store)
        if #items == 0 then
          vim.notify('No macros saved', vim.log.levels.INFO)
          return
        end
        Snacks.picker({
          items = items,
          title = 'Load Macro',
          layout = {
            layout = {
              preview = false,
              width = 0.4,
              height = 0.6,
            },
          },
          format = 'text',
          confirm = function(picker, item)
            picker:close()
            if not item then return end
            local entry = store[item.text]
            if not entry then return end
            vim.fn.setreg('q', entry.content)
            vim.notify('Macro "' .. item.text .. '" loaded to @q — press q to replay')
          end,
        })
      end,
      desc = 'Load macro from store',
    },
    {
      '<leader>md',
      function()
        local store = load_store()
        local items = picker_items(store)
        if #items == 0 then
          vim.notify('No macros saved', vim.log.levels.INFO)
          return
        end
        Snacks.picker({
          items = items,
          title = 'Delete Macro',
          layout = {
            layout = {
              preview = false,
              width = 0.4,
              height = 0.6,
            },
          },
          format = 'text',
          confirm = function(picker, item)
            picker:close()
            if not item then return end
            store[item.text] = nil
            save_store(store)
            vim.notify('Macro "' .. item.text .. '" deleted')
          end,
        })
      end,
      desc = 'Delete macro from store',
    },
    {
      '<leader>mp',
      function()
        local store = load_store()
        local items = picker_items(store)
        if #items == 0 then
          vim.notify('No macros saved', vim.log.levels.INFO)
          return
        end
        Snacks.picker({
          items = items,
          title = 'Preview Macros',
          layout = {
            layout = {
              preview = true,
              width = 0.6,
              height = 0.7,
            },
          },
          format = 'text',
          preview = function(ctx)
            local entry = store[ctx.item.text]
            if not entry then return end
            local lines = {
              'Name: ' .. ctx.item.text,
              'Register: @' .. (entry.register or 'q'),
              'Saved: ' .. (entry.saved_at or 'unknown'),
              '',
              'Raw content:',
              entry.content,
              '',
              'Readable:',
              readable_macro(entry.content),
            }
            vim.api.nvim_buf_set_lines(ctx.buf, 0, -1, false, lines)
            vim.bo[ctx.buf].filetype = 'text'
          end,
        })
      end,
      desc = 'Preview macros in store',
    },
  },
}
