local fn = vim.fn

local M = {}

local bufnr_to_terminal_job_id_mapping = {}

local get_terminal_job_id = function()
	local bufnr = fn.bufnr("%")
	local terminal_job_id = bufnr_to_terminal_job_id_mapping[tostring(bufnr)]
	if not terminal_job_id then
		error("terminal_job_id is nil")
	end
	return terminal_job_id
end

---
---@param repl string
-- stylua: ignore
M.start_repl_and_link_it_with_current_buffer = function(repl)
	local bufnr = fn.bufnr("%")
    vim.cmd("command! -buffer ReplSendLineAtCursor    lua require('repl').send_line_at_cursor()")
    vim.cmd("command! -buffer ReplSendVisualSelection lua require('repl').send_visual_selection()")
    vim.cmd("command! -buffer ReplSendEntireBuffer    lua require('repl').send_entire_buffer()")

	vim.cmd("vsplit | terminal " .. repl)
	local terminal_job_id = vim.b.terminal_job_id
	if not terminal_job_id then
		error("terminal_job_id is nil")
	end
	bufnr_to_terminal_job_id_mapping[tostring(bufnr)] = terminal_job_id
end

M.send_line_at_cursor = function()
	local line_at_cursor = fn.getline(".")
	local terminal_job_id = get_terminal_job_id()
	fn.chansend(terminal_job_id, { line_at_cursor .. "\r" })
end

-- stylua: ignore
M.send_visual_selection = function()
	local terminal_job_id = get_terminal_job_id()
	local lines           = require("repl.utils").get_visual_selection()
	lines[#lines]         = lines[#lines] .. "\r"
	fn.chansend(terminal_job_id, lines)
end

-- stylua: ignore
M.send_entire_buffer = function()
    local terminal_job_id = get_terminal_job_id()
    local lines           = fn.getline(1, "$")
    lines[#lines]         = lines[#lines] .. "\r"
    fn.chansend(terminal_job_id, lines)
end

M.setup = function(opts)
    vim.cmd("command! -nargs=1 ReplStart lua require('repl').start_repl_and_link_it_with_current_buffer(<f-args>)")
end

return M
