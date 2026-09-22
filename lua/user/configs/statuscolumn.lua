local DUAL = "%C%s%=%{v:relnum != 0 ? printf('%3d', v:relnum) : '   '}│%{printf('%4d', v:lnum)} "

local M = {}

function M.apply()
	local is_file = vim.bo.buftype == ""
		and not vim.tbl_contains({ "NvimTree", "netrw" }, vim.bo.filetype)
	vim.opt_local.statuscolumn = is_file and DUAL or ""
end

return M
