-- Workaround: with Neovim 0.12, `vim.lsp.enable()` does not attach to buffers
-- opened before the LSP configs were registered, and nvimdots' `:LspStart`
-- fallback no longer exists in nvim-lspconfig. Re-fire FileType so enabled
-- servers attach to already-open buffers.
for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
	if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == "" and vim.bo[bufnr].filetype ~= "" then
		vim.api.nvim_exec_autocmds("FileType", { buffer = bufnr })
	end
end
