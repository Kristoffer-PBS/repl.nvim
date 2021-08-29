local M = {}

M.get_visual_selection = function()
	local mode = vim.fn.mode()
	if not (mode == "v" or mode == "V" or "CTRL-V") then
		error("mode is not visual")
		return nil
	end
	-- stylua: ignore start
	local _, start_lnum, start_col, _ = unpack(vim.fn.getpos("'<"))
	local _, end_lnum  , end_col,   _ = unpack(vim.fn.getpos("'>"))
	-- stylua: ignore end
	-- handle if visual selection was started and then moved "upward"
	if end_lnum < start_lnum then
		start_lnum, end_lnum = end_lnum, start_lnum
	end
    local lines = vim.fn.getline(start_lnum, end_lnum)
    return lines
end

return M
