return {
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			-- Custom action to open all selected files in tabs
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			local function open_multiple_files(prompt_bufnr)
				local picker = action_state.get_current_picker(prompt_bufnr)
				local selections = picker:get_multi_selection()

				actions.close(prompt_bufnr)

				for _, entry in ipairs(selections) do
					vim.cmd("edit " .. entry.path)
				end
			end

			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
				defaults = {
					--file_ignore_patterns = { "vendor", "node_modules", ".git/" }, -- Ignore node_modules and .git folders
					--find_command = { "fd", "--type", "f", "--no-ignore", "--hidden" },
					mappings = {
						i = {
							["<C-o>"] = open_multiple_files, -- Ctrl+o opens selected files
						},
					},
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--no-ignore", -- **This is the added flag**
						"--hidden", -- **Also this flag. The combination of the two is the same as `-uu`**
					},
				},
				pickers = {
					find_files = {
						--find_command = { "fd", "--type", "f", "--no-ignore", "--hidden" },
						hidden = true,
						no_ignore = false,
					},
				},
			})
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<C-p>", builtin.find_files, {})
			-- vim.api.nvim_set_keymap(
			--   "n",
			--   "<C-p>",
			--   ':lua require"telescope.builtin".find_files({ hidden = true, no_ignore = false })<CR>',
			--   { noremap = true, silent = true }
			-- )
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
			vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, { desc = "Recent files" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })

			require("telescope").load_extension("ui-select")
		end,
	},
}
