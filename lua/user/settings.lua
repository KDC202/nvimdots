-- Please check `lua/core/settings.lua` to view the full list of configurable settings
local settings = {}

-- Examples
settings["use_ssh"] = false

settings["colorscheme"] = "catppuccin"

settings["ai_api_key"] = "AIAPI_KEY"

settings["ai_adapters"] = {
	openrouter = {
		type = "openai-compatible",
		name = "OpenRouter",
		base_url = "https://openrouter.ai/api",
		chat_url = "/v1/chat/completions",
		models = { "deepseek/deepseek-v4-flash" },
		default_model = "deepseek/deepseek-v4-flash",
	},
}

settings["codecompanion_adapter"] = "openrouter"

settings["use_copilot"] = false

settings["edit_prediction_source"] = "copilot"

settings["pred_adapter"] = "openrouter"

settings["pred_model"] = "deepseek/deepseek-v4-flash"

settings["pred_optional_params"] = {
	max_tokens = 128,
}

-- NOTE: nvimdots merges user lists via `list_extend`, so trimming requires
-- function overrides (see modules/utils/init.lua `tbl_recursive_merge`).
settings["lsp_deps"] = function(default)
	return { "clangd", "ruff", "pyrefly", "lua_ls" }
end

settings["null_ls_deps"] = function(default)
	return { "clang_format" }
end

settings["dap_deps"] = function(default)
	return { "codelldb", "python" }
end

return settings
