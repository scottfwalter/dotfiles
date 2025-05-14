return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		vim.keymap.set("n", "<leader>n", ":Neotree filesystem reveal left<CR>", {})
		vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
		require("neo-tree").setup({
			close_if_last_window = false,
			enable_git_status = true,
			enable_diagnostics = true,
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
					never_show = { ".DS_Store", "thumbs.db" },
				},
				follow_current_file = {
					enabled = true,
				},
				use_libuv_file_watcher = true,
				window = {
					mappings = {
						["<space>"] = "none",
						["<cr>"] = "open",
						["l"] = "open",
						["h"] = "close_node",
						["<bs>"] = "navigate_up",
					},
				},
			},
			buffers = {
				window = {
					mappings = {
						["<space>"] = "none",
						["<cr>"] = "open",
						["l"] = "open",
						["h"] = "close_node",
						["<bs>"] = "navigate_up",
					},
				},
			},
		})
	end,
}
