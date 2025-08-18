-- Define the demo_select function
local function demo_select()
	local show_folder = "Show folder in finder"
	local format_file = "Format File"
	local github_copilot_chat = "Github Copilot Chat"
	local lazy_git = "Lazy Git"
	local toggle_inline_hints = "Toggle Inline Hints"
	local json_format = "JSON Format"

	local options = {
		show_folder,
		format_file,
		github_copilot_chat,
		lazy_git,
		toggle_inline_hints,
		json_format,
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
			vim.cmd("!open %:p:h")
		elseif choice:match(format_file) then
			vim.cmd("normal! gg=G")
		elseif choice:match(toggle_inline_hints) then
			vim.cmd("ToggleHints")
		elseif choice:match(github_copilot_chat) then
			vim.cmd("CopilotChat")
		elseif choice:match(json_format) then
			vim.cmd("%!jq .")
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
