local function get_rg_matches(search, opts)
  opts = opts or {}
  local cmd = { 'rg', '--json', '--no-heading', '--line-number', '--column', '--smart-case', '--max-columns=500' }

  if opts.hidden then cmd[#cmd + 1] = '--hidden' end
  cmd[#cmd + 1] = '--glob'
  cmd[#cmd + 1] = '!.git'
  cmd[#cmd + 1] = '--glob'
  cmd[#cmd + 1] = '!node_modules'
  cmd[#cmd + 1] = '--glob'
  cmd[#cmd + 1] = '!.gitignore'

  local ok, result = pcall(function()
    return vim.fn.systemlist(vim.list_extend(cmd, { '--', search, opts.dir or '.' }))
  end)

  if not ok or vim.v.shell_error ~= 0 then return {} end

  local matches = {}
  for _, line in ipairs(result) do
    local m = vim.json.decode(line)
    if m.type == 'match' then
      local data = m.data
      local text = data.lines.text:gsub('\n$', '')
      matches[#matches + 1] = {
        file = data.path.text,
        lnum = data.line_number,
        col = data.submatches[1] and data.submatches[1].start or 1,
        text = text,
        match = data.submatches[1] and data.submatches[1].match.text or '',
      }
    end
  end
  return matches
end

function replace()
  vim.ui.input({ prompt = 'Search: ' }, function(search)
    if not search or search == '' then return end
    local matches = get_rg_matches(search, { dir = vim.fn.getcwd() })
    if #matches == 0 then
      vim.notify('No matches found', vim.log.levels.INFO)
      return
    end

    vim.ui.input({ prompt = 'Replace: ' }, function(replace)
      if not replace then return end

      local items = {}
      for _, m in ipairs(matches) do
        items[#items + 1] = {
          text = m.file .. ':' .. m.lnum .. ':' .. m.text,
          file = m.file,
          lnum = m.lnum,
          col = m.col,
          match = m.match,
          replace = replace,
          checked = true,
        }
      end

      Snacks.picker({
        items = items,
        title = 'Search & Replace (' .. #matches .. ' matches)',
        layout = {
          layout = {
            preview = true,
            width = 0.8,
            height = 0.8,
          },
        },
        format = function(item)
          local prefix = item.checked and '●' or '○'
          return { { prefix .. ' ' .. item.text, 'Normal' } }
        end,
        preview = function(ctx)
          local lines = {
            'File: ' .. ctx.item.file,
            'Line: ' .. ctx.item.lnum,
            '',
            'Search:  ' .. ctx.item.match,
            'Replace: ' .. ctx.item.replace,
            '',
            'Original line:',
            ctx.item.text:match(':%d+:(.*)$') or ctx.item.text,
          }
          vim.api.nvim_buf_set_lines(ctx.buf, 0, -1, false, lines)
          vim.bo[ctx.buf].filetype = 'text'
        end,
        win = {
          input = {
            keys = {
              ['<Tab>'] = {
                function(picker)
                  local item = picker:get_item()
                  if item then
                    item.checked = not item.checked
                    picker:refresh()
                  end
                end,
                mode = { 'i', 'n' },
                desc = 'Toggle match',
              },
              ['<CR>'] = {
                function(picker)
                  local selected = {}
                  for _, item in ipairs(picker:selected()) do
                    if item.checked then
                      selected[#selected + 1] = item
                    end
                  end
                  picker:close()
                  if #selected == 0 then
                    vim.notify('No matches selected', vim.log.levels.INFO)
                    return
                  end
                  apply_replacements(selected, search, replace)
                end,
                mode = { 'i', 'n' },
                desc = 'Apply replacements',
              },
            },
          },
        },
        confirm = false,
      })
    end)
  end)
end

function file_replace()
  local file = vim.api.nvim_buf_get_name(0)
  if file == '' then
    vim.notify('No file', vim.log.levels.WARN)
    return
  end

  vim.ui.input({ prompt = 'Search: ' }, function(search)
    if not search or search == '' then return end
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local matches = {}
    for i, line in ipairs(lines) do
      local s, e = line:find(search, 1, true)
      if s then
        matches[#matches + 1] = {
          text = i .. ':' .. line,
          lnum = i,
          col = s,
          match = line:sub(s, e),
          checked = true,
        }
      end
    end

    if #matches == 0 then
      vim.notify('No matches in current file', vim.log.levels.INFO)
      return
    end

    vim.ui.input({ prompt = 'Replace: ' }, function(replace)
      if not replace then return end

      local items = {}
      for _, m in ipairs(matches) do
        items[#items + 1] = {
          text = m.text,
          lnum = m.lnum,
          col = m.col,
          match = m.match,
          replace = replace,
          checked = true,
        }
      end

      Snacks.picker({
        items = items,
        title = 'Replace in file (' .. #matches .. ' matches)',
        layout = {
          layout = {
            preview = false,
            width = 0.6,
            height = 0.7,
          },
        },
        format = function(item)
          local prefix = item.checked and '●' or '○'
          return { { prefix .. ' ' .. item.text, 'Normal' } }
        end,
        win = {
          input = {
            keys = {
              ['<Tab>'] = {
                function(picker)
                  local item = picker:get_item()
                  if item then
                    item.checked = not item.checked
                    picker:refresh()
                  end
                end,
                mode = { 'i', 'n' },
                desc = 'Toggle match',
              },
            },
          },
        },
        confirm = function(picker, item)
          picker:close()
          if not item then return end
          local selected = {}
          for _, it in ipairs(picker:selected()) do
            if it.checked then
              selected[#selected + 1] = it
            end
          end
          if #selected == 0 then
            vim.notify('Nothing selected', vim.log.levels.INFO)
            return
          end
          table.sort(selected, function(a, b) return a.lnum > b.lnum end)
          for _, s in ipairs(selected) do
            local line = vim.api.nvim_buf_get_lines(0, s.lnum - 1, s.lnum, false)[1]
            if line then
              local new_line = line:gsub(vim.pesc(s.match), s.replace, 1)
              vim.api.nvim_buf_set_lines(0, s.lnum - 1, s.lnum, false, { new_line })
            end
          end
          vim.notify(#selected .. ' replacements applied')
        end,
      })
    end)
  end)
end

function apply_replacements(selected, search, replace)
  table.sort(selected, function(a, b)
    if a.file == b.file then return a.lnum > b.lnum end
    return a.file > b.file
  end)

  local by_file = {}
  for _, s in ipairs(selected) do
    if not by_file[s.file] then by_file[s.file] = {} end
    by_file[s.file][#by_file[s.file] + 1] = s
  end

  local count = 0
  for file, file_matches in pairs(by_file) do
    local lines = vim.fn.readfile(file)
    for _, m in ipairs(file_matches) do
      local line = lines[m.lnum]
      if line then
        lines[m.lnum] = line:gsub(vim.pesc(m.match), m.replace, 1)
        count = count + 1
      end
    end
    vim.fn.writefile(lines, file)
  end

  vim.notify(count .. ' replacements applied across ' .. #vim.tbl_keys(by_file) .. ' files')
end

return {
  keys = {
    { '<leader>sr', replace, desc = 'Search & replace (project)' },
    { '<leader>sR', file_replace, desc = 'Search & replace (file)' },
  },
}
