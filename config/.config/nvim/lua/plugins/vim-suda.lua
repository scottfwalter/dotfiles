return {
	"lambdalisue/vim-suda",
	cmd = { "SudaRead", "SudaWrite" },
	config = function()
		vim.g.suda_smart_edit = 1
	end,
}
