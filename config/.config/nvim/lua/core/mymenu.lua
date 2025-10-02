-- Define the demo_select function
local function demo_select()
	local show_folder = "Show folder in finder"
	local format_file = "Format File"
	local github_copilot_chat = "Github Copilot Chat"
	local lazy_git = "Lazy Git"
	local toggle_inline_hints = "Toggle Inline Hints"
	local json_format = "JSON Format"
	local toggle_terminal = "Terminal"
	local copy_file_path = "Copy file path to clipboard"
	local replace_buffer = "Replace buffer with clipboard"
	local toggle_formatting = "Toggle Prettier"

	local options = {
		show_folder,
		format_file,
		github_copilot_chat,
		lazy_git,
		toggle_inline_hints,
		json_format,
		toggle_terminal,
		copy_file_path,
		replace_buffer,
		toggle_formatting,
	}

	table.sort(options)

	local prompt = "Please select an option:"
	vim.ui.select(options, {
		prompt = prompt,
		format_item = function(item)
			return "→ " .. item
		end,
	}, function(choice)
		-- Execute different actions based on the selection
		if not choice then
			return
		end

		if choice:match(lazy_git) then
			vim.cmd("LazyGit")
		elseif choice:match(show_folder) then
			vim.cmd("silent !open %:p:h")
		elseif choice:match(format_file) then
			vim.cmd("normal! gg=G")
		elseif choice:match(toggle_inline_hints) then
			vim.cmd("ToggleHints")
		elseif choice:match(github_copilot_chat) then
			vim.cmd("CopilotChat")
		elseif choice:match(json_format) then
			vim.cmd("%!jq .")
		elseif choice:match(toggle_terminal) then
			vim.cmd("lua require('betterTerm').open() ")
		elseif choice:match(replace_buffer) then
			vim.cmd("%d | put +")
		elseif choice:match(copy_file_path) then
			vim.cmd("let @+ = expand('%:p')")
		elseif choice:match(toggle_formatting) then
			vim.cmd("TogglePrettier")
		end
	end)
end

-- Register the custom command :scott
vim.api.nvim_create_user_command("Scott", function()
	demo_select()
end, {})

vim.keymap.set("n", "<leader>m", function()
	demo_select()
end, { desc = "My Menu" })
