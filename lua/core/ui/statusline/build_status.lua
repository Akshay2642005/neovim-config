local M = {}

local SPINNER_INTERVAL = 120
local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local IDLE_ICON = " 󱌢"

local redraw_timer = nil

local function stop_redraw_timer()
  if redraw_timer then
    pcall(vim.fn.timer_stop, redraw_timer)
    redraw_timer = nil
  end
end

local function ensure_redraw_timer()
  if redraw_timer then return end
  redraw_timer = vim.fn.timer_start(SPINNER_INTERVAL, function()
    vim.schedule(function()
      if redraw_timer then vim.cmd("redrawstatus") end
    end)
  end, { ["repeat"] = -1 })
end

---@param button number
function _G.StatuslineBuildClick(button)
  if button == 3 then
    vim.g.build_task = nil
    vim.notify("Build task cleared", vim.log.levels.INFO)
    vim.cmd("redrawstatus")
    return
  end

  local task_name = vim.g.build_task
  if task_name and task_name ~= "" then
    local ok1, overseer = pcall(require, "overseer")
    local ok2, task_list = pcall(require, "overseer.task_list")
    if ok1 and ok2 then
      local tasks = task_list.list_tasks({ include_ephemeral = true })
      for _, task in ipairs(tasks) do
        if task.name == task_name then
          overseer.run_task(task)
          return
        end
      end
    end
    vim.cmd("OverseerRun")
    return
  end

  vim.cmd("OverseerRun")
end

function _G.StatuslineBuildNull() end

--- Right: build icon — spinner when running, clickable when idle
function M.icon()
  local ok, task_list = pcall(require, "overseer.task_list")

  if ok then
    local tasks = task_list.list_tasks({ include_ephemeral = true })
    for _, task in ipairs(tasks) do
      if task.status == "RUNNING" then
        vim.g.build_task = task.name
        ensure_redraw_timer()
        local frame = math.floor(vim.uv.now() / SPINNER_INTERVAL) % #spinner + 1
        return "%#StatusLineBuildRunning# " .. spinner[frame] .. " " .. task.name:upper() .. " %*"
      end
    end
  end

  stop_redraw_timer()

  local pinned = vim.g.build_task
  if pinned and pinned ~= "" then
    return "%@v:lua.StatuslineBuildClick@%#StatusLineMedium#" .. IDLE_ICON .. " " .. pinned:upper() .. " %*%@v:lua.StatuslineBuildNull@"
  end
  return "%@v:lua.StatuslineBuildClick@%#StatusLineMedium#" .. IDLE_ICON .. " %*%@v:lua.StatuslineBuildNull@"
end

return M
