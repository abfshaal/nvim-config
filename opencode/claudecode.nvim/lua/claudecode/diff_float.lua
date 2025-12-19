local M = {}
local state = {
  win = nil,
  buf = nil,
  tab_name = nil,
  hidden = false,
}

local function is_change_line(text)
  if not text or text == "" then
    return false
  end
  if text:sub(1, 2) == "@@" then
    return true
  end
  if text:sub(1, 3) == "+++" or text:sub(1, 3) == "---" then
    return false
  end
  local first = text:sub(1, 1)
  return first == "+" or first == "-"
end

local function is_hunk_start(buf, line)
  local text = vim.api.nvim_buf_get_lines(buf, line, line + 1, false)[1]
  if not text then
    return false
  end

  if text:sub(1, 2) == "@@" then
    return true
  end

  if not is_change_line(text) then
    return false
  end

  if line == 0 then
    return true
  end

  local prev = vim.api.nvim_buf_get_lines(buf, line - 1, line, false)[1]
  if not prev then
    return true
  end

  if prev:match("^@@") then
    return true
  end

  return not is_change_line(prev)
end

local function find_hunk_line(buf, start_line, direction)
  if not (buf and vim.api.nvim_buf_is_valid(buf)) then
    return nil
  end

  local line_count = vim.api.nvim_buf_line_count(buf)
  if line_count == 0 then
    return nil
  end

  local step = direction == "forward" and 1 or -1
  local line = start_line + step

  while line >= 0 and line < line_count do
    if is_hunk_start(buf, line) then
      return line
    end
    line = line + step
  end

  return nil
end

local function jump_to_hunk(direction)
  if not (state.win and vim.api.nvim_win_is_valid(state.win)) then
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(state.win)
  local current_line = cursor[1] - 1
  local target_line = find_hunk_line(state.buf, current_line, direction)

  if target_line then
    vim.api.nvim_win_set_cursor(state.win, { target_line + 1, 0 })
  else
    local msg = direction == "forward" and "No next diff hunk" or "No previous diff hunk"
    vim.notify("Claude diff: " .. msg, vim.log.levels.INFO)
  end
end

local function close_window()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    pcall(vim.api.nvim_win_close, state.win, true)
  end
  state.win = nil
end

local function delete_buffer()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
  end
  state.buf = nil
end

local function destroy_state()
  close_window()
  delete_buffer()
  state.tab_name = nil
  state.hidden = false
end

local function open_window()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_set_current_win(state.win)
    state.hidden = false
    return true
  end

  if not (state.buf and vim.api.nvim_buf_is_valid(state.buf)) then
    return false
  end

  local ui = vim.api.nvim_list_uis()[1]
  if not ui then
    vim.notify("Claude diff: no available UI to show floating window", vim.log.levels.ERROR)
    return false
  end

  local width = math.floor(ui.width * 0.8)
  local height = math.floor(ui.height * 0.8)
  local row = math.floor((ui.height - height) / 2)
  local col = math.floor((ui.width - width) / 2)

  local win = vim.api.nvim_open_win(state.buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
  })

  state.win = win
  state.hidden = false
  return true
end

local function close_float(action)
  if action == "accept" then
    vim.cmd("ClaudeCodeDiffAccept")
  elseif action == "deny" then
    vim.cmd("ClaudeCodeDiffDeny")
  end

  destroy_state()
end

function M.open(diff_lines, tab_name)
  if type(diff_lines) == "string" then
    diff_lines = vim.split(diff_lines, "\n", { plain = true })
  end

  destroy_state()

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "filetype", "diff")
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")

  local lines = { "# Claude diff (a=accept, q=reject)", "" }
  vim.list_extend(lines, diff_lines)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  state.buf = buf
  state.tab_name = tab_name
  if tab_name then
    vim.b[buf].claudecode_diff_tab_name = tab_name
  end

  local opts = { buffer = buf, nowait = true, noremap = true, silent = true }
  vim.keymap.set("n", "a", function() close_float("accept") end, opts)
  vim.keymap.set("n", "q", function() close_float("deny") end, opts)
  vim.keymap.set("n", "<Esc>", function() close_float("deny") end, opts)
  vim.keymap.set("n", "]h", function() jump_to_hunk("forward") end, opts)
  vim.keymap.set("n", "[h", function() jump_to_hunk("backward") end, opts)

  if open_window() then
    local first_hunk = find_hunk_line(buf, -1, "forward")
    if first_hunk then
      vim.api.nvim_win_set_cursor(state.win, { first_hunk + 1, 0 })
    end
  end
end

function M.close(tab_name)
  if tab_name and state.tab_name and tab_name ~= state.tab_name then
    return
  end
  destroy_state()
end

function M.hide(tab_name)
  if tab_name and state.tab_name and tab_name ~= state.tab_name then
    return false
  end
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    return false
  end
  if not (state.win and vim.api.nvim_win_is_valid(state.win)) then
    state.hidden = true
    return false
  end
  close_window()
  state.hidden = true
  return true
end

function M.show(tab_name)
  if tab_name and state.tab_name and tab_name ~= state.tab_name then
    return false
  end
  return open_window()
end

function M.current_tab_name()
  return state.tab_name
end

function M.is_hidden()
  return state.hidden
end

return M
