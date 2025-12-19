local M = {}
local state = {
  win = nil,
  buf = nil,
  tab_name = nil,
}

local function cleanup_state()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    pcall(vim.api.nvim_win_close, state.win, true)
  end
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    pcall(vim.api.nvim_buf_delete, state.buf, { force = true })
  end
  state.win, state.buf, state.tab_name = nil, nil, nil
end

local function close_float(action)
  if action == "accept" then
    vim.cmd("ClaudeCodeDiffAccept")
  elseif action == "deny" then
    vim.cmd("ClaudeCodeDiffDeny")
  end

  cleanup_state()
end

function M.open(diff_lines, tab_name)
  if type(diff_lines) == "string" then
    diff_lines = vim.split(diff_lines, "\n", { plain = true })
  end

  cleanup_state()

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "filetype", "diff")
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

  local lines = { "# Claude diff (a=accept, q=reject)", "" }
  vim.list_extend(lines, diff_lines)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)

  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(ui.width * 0.8)
  local height = math.floor(ui.height * 0.8)
  local row = math.floor((ui.height - height) / 2)
  local col = math.floor((ui.width - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
  })

  state.win = win
  state.buf = buf
  state.tab_name = tab_name
  if tab_name then
    vim.b[buf].claudecode_diff_tab_name = tab_name
  end

  local opts = { buffer = buf, nowait = true, noremap = true, silent = true }
  vim.keymap.set("n", "a", function() close_float("accept") end, opts)
  vim.keymap.set("n", "q", function() close_float("deny") end, opts)
  vim.keymap.set("n", "<Esc>", function() close_float("deny") end, opts)
end

function M.close(tab_name)
  if tab_name and state.tab_name and tab_name ~= state.tab_name then
    return
  end
  cleanup_state()
end

function M.current_tab_name()
  return state.tab_name
end

return M
