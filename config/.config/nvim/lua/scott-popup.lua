-- Define the demo_select function
local function demo_select()
	local options = {
		"Lazy Git",
		"Delete Current Line",
		"Execute Macro a",
		"Format File",
	}

	local prompt = "Please select an option:"

	vim.ui.select(options, {
		prompt = prompt,
		format_item = function(item)
			return "→ " .. item
		end,
	}, function(choice)
		-- if choice then
		--   vim.notify("You selected: " .. choice, vim.log.levels.INFO)
		-- else
		--   vim.notify("Selection cancelled", vim.log.levels.WARN)
		-- end

		-- local option_number = tonumber(choice:match("Option (%d+)"))
		-- if option_number == 1 then
		--   -- Execute the LazyGit command
		--   vim.cmd("LazyGit")
		--   goto done
		-- end
		--
		-- if option_number == 2 then
		--   -- Execute dd keystroke (delete current line)
		--   vim.cmd("normal! dd")
		--   goto done
		-- end
		--
		-- if option_number == 3 then
		--   -- Execute macro a
		--   vim.cmd("normal! @a")
		--   goto done
		-- end
		--
		-- if option_number == 4 then
		--   -- Reindent the entire file (gg=G)
		--   vim.cmd("normal! gg=G")
		--   goto done
		-- end
		--
		-- ::done::

		-- Execute different actions based on the selection
		if choice and choice:match("Lazy Git") then
			-- Execute the LazyGit command
			vim.cmd("LazyGit")
		elseif choice and choice:match("Delete Current Line") then
			-- Execute dd keystroke (delete current line)
			vim.cmd("normal! dd")
		elseif choice and choice:match("Execute Macro a") then
			-- Execute macro a
			vim.cmd("normal! @a")
		elseif choice and choice:match("Format File") then
			-- Format the file
			vim.cmd("normal! gg=G")
		end
	end)
end

-- Register the custom command :scott
vim.api.nvim_create_user_command("Scott", function()
	demo_select()
end, {})

vim.keymap.set("n", "<leader>m", function()
	demo_select()
end, { desc = "Show selection menu" })
