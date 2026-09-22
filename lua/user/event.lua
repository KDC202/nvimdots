local definitions = {
	-- Example
	bufs = {
		{ "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
	},
	wins = {
		-- Dual-column statuscolumn for file buffers only (see user/configs/statuscolumn.lua)
		{ "BufWinEnter,WinEnter", "*", "lua require('user.configs.statuscolumn').apply()" },
	},
	ft = {
		{ "FileType", "*", "lua require('user.configs.statuscolumn').apply()" },
	},
}

return definitions
