local function copy_diagnostics_to_clipboard()
	local diagnostics = vim.diagnostic.get(0) -- 0 for current buffer
	local lines = {}

	for _, diag in ipairs(diagnostics) do
		local line = string.format(
			"%d:%d %s: %s",
			diag.lnum + 1,
			diag.col + 1,
			vim.diagnostic.severity[diag.severity],
			diag.message
		)
		table.insert(lines, line)
	end

	if #lines > 0 then
		vim.fn.setreg("+", table.concat(lines, "\n"))
		print(#lines .. " diagnostics copied to clipboard")
	else
		print("No diagnostics found")
	end
end

-- Create a command for it
vim.api.nvim_create_user_command("CopyDiagnostics", copy_diagnostics_to_clipboard, {})
