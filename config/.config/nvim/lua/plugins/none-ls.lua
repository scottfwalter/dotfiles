return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim", -- ensure dependencies are installed
	},
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting -- to setup formatters
		local diagnostics = null_ls.builtins.diagnostics -- to setup linters

		-- Formatters & linters for mason to install
		require("mason-null-ls").setup({
			ensure_installed = {
				"prettier", -- ts/js formatter
				"eslint_d", -- ts/js linter
				"shfmt", -- Shell formatter
				"checkmake", -- linter for Makefiles
				-- 'stylua', -- lua formatter; Already installed via Mason
				-- 'ruff', -- Python linter and formatter; Already installed via Mason
			},
			automatic_installation = true,
		})

		local sources = {
			diagnostics.checkmake,
			formatting.prettier.with({
				filetypes = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"html",
					"json",
					"yaml",
					"markdown",
					"css",
					"scss",
					"vue",
					"svelte",
				},
			}),
			--		formatting.prettier.with({ filetypes = { "html", "json", "yaml", "markdown" } }),
			formatting.stylua,
			formatting.shfmt.with({ args = { "-i", "4" } }),
			formatting.terraform_fmt,
			require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
			require("none-ls.formatting.ruff_format"),
			--       null_ls.builtins.diagnostics.eslint,
			-- null_ls.builtins.code_actions.eslint,
			-- null_ls.builtins.formatting.eslint,
			--
			-- JavaScript/TypeScript - use eslint_d for everything
			require("none-ls.diagnostics.eslint_d").with({
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			}),
			require("none-ls.code_actions.eslint_d").with({
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			}),
			require("none-ls.formatting.eslint_d").with({
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
			}),
		}

		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
		null_ls.setup({
			-- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
			sources = sources,
			-- you can reuse a shared lspconfig on_attach callback here
			on_attach = function(client, bufnr)
				if client:supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({ async = false })
						end,
					})
				end
			end,
		})

		local null_ls = require("null-ls")

		-- Toggle function
		local function toggle_prettier()
			local sources2 = null_ls.get_sources()
			local prettier_enabled = false

			for _, source in ipairs(sources2) do
				if source.name == "prettier" then
					prettier_enabled = true
					break
				end
			end

			if prettier_enabled then
				null_ls.disable({ name = "prettier" })
				print("Prettier disabled")
			else
				null_ls.enable({ name = "prettier" })
				print("Prettier enabled")
			end
		end

		-- Create a command
		vim.api.nvim_create_user_command("TogglePrettier", toggle_prettier, {})

		-- Or bind to a key
		--vim.keymap.set("n", "<leader>tp", toggle_prettier, { desc = "Toggle Prettier" })
	end,
}
