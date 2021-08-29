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

M.get_code_cell = function(delimiter)
    local curr_lnum = vim.fn.line(".")

    local start_lnum = 1
    local end_lnum = vim.fn.line("$")
    local commentstring = vim.bo.commentstring
    local cell_delimiter = string.format(commentstring, delimiter)
    local use_start_of_buffer = false
    local use_end_of_buffer = false



    for i = curr_lnum, start_lnum, -1 do
        local line = vim.fn.getline(i)
        if line == cell_delimiter then
            if i == start_lnum then use_start_of_buffer = true end
            start_lnum = i
            break
        end
    end
    for i = curr_lnum, end_lnum, 1 do
        local line = vim.fn.getline(i)
        if line == cell_delimiter then
            if i == end_lnum then use_end_of_buffer = true end
            end_lnum = i
            break
        end
    end

    local lines = vim.fn.getline(start_lnum + (use_start_of_buffer and 1 or 0), end_lnum - (use_end_of_buffer and 1 or 0))
    return lines
end

return M
