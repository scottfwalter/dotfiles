return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		-- add any options here
		lsp = {
			-- Enables LSP progress, messages, etc.
			message = {
				enabled = true,
			},
		},
		messages = {
			enabled = true, -- enables the message history UI
			view_search = false,
		},
		presets = {
			command_palette = true,
			long_message_to_split = true,
			lsp_doc_border = true,
		},
		routes = {
			{
				filter = {
					event = "msg_show",
					kind = "",
					find = "@recording",
				},
				opts = { skip = false },
			},
		},
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
	},
}
