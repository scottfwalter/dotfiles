require("core.options") -- Load general options
require("core.keymaps") -- Load general keymaps
require("core.snippets") -- Custom code snippets
require("core.help-panel") -- Help panel for NeoVim
require("core.mymenu") -- Custom menu for NeoVim
require("core.macros") -- Macros for NeoVim
require("core.commands") -- Custom commands

-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Set up plugins
require("lazy").setup({
	require("plugins.neotree"),
	require("plugins.catppuccin"),
	require("plugins.bufferline"),
	require("plugins.lualine"),
	require("plugins.treesitter"),
	require("plugins.telescope"),
	require("plugins.lsp"),
	require("plugins.autocompletion"),
	require("plugins.none-ls"),
	require("plugins.gitsigns"),
	require("plugins.alpha"),
	require("plugins.indent-blankline"),
	require("plugins.misc"),
	require("plugins.comment"),
	require("plugins.ghcopilot"),
	require("plugins.lazygit"),
	require("plugins.mini-indent"),
	require("plugins.mini-pairs"),
	require("plugins.vim-surround"),
	require("plugins.vim-visual-multi"),
	require("plugins.trouble"),
	require("plugins.better-term"),
	require("plugins.snacks"),
	require("plugins.claudecode"),
	require("plugins.vim-suda"),
	require("plugins.markdown"),
}, {
	-- performance = {
	-- 	cache = {
	-- 		enabled = true,
	-- 	},
	-- 	reset_packpath = true,
	-- 	rtp = {
	-- 		reset = true,
	-- 		paths = {},
	-- 		disabled_plugins = {
	-- 			"gzip",
	-- 			"matchit",
	-- 			"matchparen",
	-- 			"netrwPlugin",
	-- 			"tarPlugin",
	-- 			"tohtml",
	-- 			"tutor",
	-- 			"zipPlugin",
	-- 		},
	-- 	},
	-- },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
