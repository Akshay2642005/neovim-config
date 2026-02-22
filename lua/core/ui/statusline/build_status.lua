local M                  = {}
local HIDE_AFTER_SUCCESS = 3
local HIDE_AFTER_FAILURE = 6
local SPINNER_INTERVAL   = 120
local spinner            = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_idx        = 1
local redraw_timer       = nil
local hide_until_typing  = false
local last_seen          = {}

local function task_sort_key(task)
  -- prefer updated_at, fall back to start_time, then id
  return task.updated_at or task.start_time or task.id or 0
end

local function pick_task(tasks)
  local running = nil
  local last_done = nil
  for _, task in ipairs(tasks) do
    if task.status == "RUNNING" then
      if not running or task_sort_key(task) > task_sort_key(running) then
        running = task
      end
    elseif task.status == "SUCCESS" or task.status == "FAILURE" then
      if not last_done or task_sort_key(task) > task_sort_key(last_done) then
        last_done = task
      end
    end
  end
  return running or last_done
end

local function ensure_timer()
  if redraw_timer then return end
  redraw_timer = vim.fn.timer_start(
    SPINNER_INTERVAL,
    function()
      vim.schedule(function() vim.cmd("redrawstatus") end)
    end,
    { ["repeat"] = -1 }
  )
end

vim.api.nvim_create_autocmd({ "InsertEnter", "CmdlineEnter" }, {
  callback = function()
    hide_until_typing = true
  end,
})

function _G.StatuslineBuildClick()
  vim.cmd("OverseerOpen")
end

function M.debug()
  local ok, task_list = pcall(require, "overseer.task_list")
  if not ok then
    print("overseer not found")
    return
  end
  local tasks = task_list.list_tasks({ include_ephemeral = true })
  for _, t in ipairs(tasks) do
    print(string.format("id=%s name=%s status=%s updated_at=%s start_time=%s",
      tostring(t.id), tostring(t.name), tostring(t.status),
      tostring(t.updated_at), tostring(t.start_time)))
  end
end

function M.component()
  local ok, task_list = pcall(require, "overseer.task_list")
  if not ok then return "" end

  local tasks = task_list.list_tasks({ include_ephemeral = true })
  if #tasks == 0 then return "" end

  local task = pick_task(tasks)
  if not task then return "" end

  local status = task.status
  local now = vim.loop.now() / 1000
  local seen = last_seen[task.id]

  if status == "RUNNING" then
    hide_until_typing = false
    if seen and seen.status ~= "RUNNING" then
      last_seen[task.id] = nil
    end
    ensure_timer()
    spinner_idx = (spinner_idx % #spinner) + 1
    return table.concat({
      "%@v:lua.StatuslineBuildClick@",
      "%#StatusLineBuildRunning# ",
      spinner[spinner_idx],
      " BUILD: RUNNING",
      "%*%T",
    })
  end

  if status == "SUCCESS" or status == "FAILURE" then
    if hide_until_typing then return "" end

    if not seen or seen.status ~= status then
      last_seen[task.id] = { status = status, done_at = now }
      seen = last_seen[task.id]
    end

    local timeout = status == "SUCCESS" and HIDE_AFTER_SUCCESS or HIDE_AFTER_FAILURE
    if (now - seen.done_at) > timeout then
      return ""
    end

    ensure_timer()

    if status == "SUCCESS" then
      return table.concat({
        "%@v:lua.StatuslineBuildClick@",
        "%#StatusLineBuildSuccess# ✔ BUILD: OK",
        "%*%T",
      })
    else
      return table.concat({
        "%@v:lua.StatuslineBuildClick@",
        "%#StatusLineBuildFailure# ✘ BUILD: FAILURE",
        "%*%T",
      })
    end
  end

  return ""
end

return M
