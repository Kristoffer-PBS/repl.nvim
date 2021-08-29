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

-- stylua: ignore
M.get_code_cell = function(delimiter)
    local curr_lnum      = vim.fn.line(".")
    local start_lnum     = 1
    local end_lnum       = vim.fn.line("$")
    local commentstring  = vim.bo.commentstring
    local cell_delimiter = string.format(commentstring, delimiter)
    local curr_line      = vim.fn.getline(curr_lnum)
    -- The edge case of the cursor being on a line with the cell delimiter
    -- is handled by returning nil
    if curr_line == cell_delimiter then
        return nil
    end

    for i = curr_lnum, start_lnum, -1 do
        local line = vim.fn.getline(i)
        if line == cell_delimiter then
            start_lnum = i + 1
            break
        end
    end

    for i = curr_lnum, end_lnum, 1 do
        local line = vim.fn.getline(i)
        if line == cell_delimiter then
            end_lnum = i - 1
            break
        end
    end

    local lines = vim.fn.getline(start_lnum, end_lnum)
    return lines
end

return M
