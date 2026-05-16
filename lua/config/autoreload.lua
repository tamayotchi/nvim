local M = {}

local timer
local augroup = vim.api.nvim_create_augroup("nvim_autoreload", { clear = true })

M.interval_ms = 1000

local function can_check_buffer(buf)
  return vim.api.nvim_buf_is_loaded(buf)
    and vim.api.nvim_buf_get_name(buf) ~= ""
    and vim.bo[buf].buftype == ""
    and not vim.bo[buf].modified
end

function M.check()
  -- Avoid interfering with command-line editing.
  if vim.fn.getcmdwintype() ~= "" then
    return
  end

  -- Only reload buffers without unsaved local edits. This keeps external agent
  -- changes live while avoiding accidental loss of work in modified buffers.
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if can_check_buffer(buf) then
      pcall(vim.cmd, ("silent! checktime %d"):format(buf))
    end
  end
end

function M.start_timer()
  if timer then
    timer:stop()
    timer:close()
  end

  timer = vim.uv.new_timer()
  timer:start(M.interval_ms, M.interval_ms, vim.schedule_wrap(M.check))
end

function M.stop_timer()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

function M.setup(opts)
  opts = opts or {}
  M.interval_ms = opts.interval_ms or M.interval_ms

  vim.o.autoread = true

  vim.api.nvim_clear_autocmds({ group = augroup })
  vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave", "BufEnter", "CursorHold", "CursorHoldI" }, {
    group = augroup,
    callback = M.check,
  })

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = augroup,
    callback = M.stop_timer,
  })

  M.start_timer()
end

return M
