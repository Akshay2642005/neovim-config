local M = {}

-- gutter hierarchy ----------------------------------------------------------
-- With 'relativenumber' on, the only number that means anything is the
-- cursor's: everything else is just a distance. cold.nvim leaves
-- LineNrAbove/LineNrBelow undefined (they fall back to LineNr), so the whole
-- gutter renders at one flat brightness and the cursor line has to compete
-- with 30 identical-looking neighbours. Give the three roles distinct weights.

---@param c integer 24-bit RGB
---@return integer r, integer g, integer b
local function rgb(c)
  return (c >> 16) & 0xFF, (c >> 8) & 0xFF, c & 0xFF
end

---@param fg integer foreground, 24-bit RGB
---@param bg integer background, 24-bit RGB
---@param t number 0..1, how far to pull fg toward bg
---@return integer
local function blend(fg, bg, t)
  local fr, fg_, fb = rgb(fg)
  local br, bg_, bb = rgb(bg)
  local function mix(a, b)
    return math.floor(a + (b - a) * t + 0.5)
  end
  return (mix(fr, br) << 16) | (mix(fg_, bg_) << 8) | mix(fb, bb)
end

function M.setup()
  local line_nr = vim.api.nvim_get_hl(0, { name = 'LineNr', link = false })
  local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
  local cursorline = vim.api.nvim_get_hl(0, { name = 'CursorLine', link = false })

  local bg = line_nr.bg or normal.bg or 0x000000
  local nr_fg = line_nr.fg or normal.fg or 0xffffff
  local full = normal.fg or nr_fg

  -- Recede: relative offsets are ambient context, not something you read
  -- head-on. Blend 40% toward the background so they sit behind the code.
  local quiet = blend(nr_fg, bg, 0.4)
  vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = quiet, bg = bg })
  vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = quiet, bg = bg })

  -- Lead: the absolute cursor line number, full brightness and bold so the
  -- eye lands on it immediately. bg comes from CursorLine so the number sits
  -- inside the current-line band instead of floating on top of it.
  vim.api.nvim_set_hl(0, 'CursorLineNr', {
    fg = full,
    bg = cursorline.bg or bg,
    bold = true,
  })
end

return M
