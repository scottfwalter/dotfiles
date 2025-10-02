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

-- Auto-run Alpha when last buffer is closed
-- vim.api.nvim_create_autocmd("BufDelete", {
-- 	callback = function()
-- 		local bufs = vim.fn.getbufinfo({ buflisted = 1 })
-- 		-- Check if this was the last listed buffer
-- 		if #bufs <= 1 then
-- 			vim.defer_fn(function()
-- 				-- Double-check we're in an empty state
-- 				local current_bufs = vim.fn.getbufinfo({ buflisted = 1 })
-- 				if
-- 					#current_bufs == 0 or (#current_bufs == 1 and vim.fn.getbufinfo(vim.fn.bufnr("%"))[1].name == "")
-- 				then
-- 					vim.cmd("Alpha")
-- 				end
-- 			end, 10) -- Small delay to ensure buffer deletion is complete
-- 		end
-- 	end,
-- })
