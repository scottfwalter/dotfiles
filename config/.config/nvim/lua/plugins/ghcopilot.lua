return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
			-- mappings = {
			-- 	complete = {
			-- 		insert = "<C-a>", -- Now mapped to Ctrl+L instead of Ctrl+Y
			-- 	},
			-- },
			window = {
				layout = "vertical",
				width = 0.3,
				position = "right",
				-- layout = "horizontal",
				-- layout = {
				--   position = "right",
				--   width = 50,
				-- },
			},
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
}
