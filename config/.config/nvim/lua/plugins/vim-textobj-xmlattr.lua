return {
	"whatyouhide/vim-textobj-xmlattr",
	dependencies = {
		"kana/vim-textobj-user", -- Required dependency
	},
	ft = { "html", "xml", "jsx", "tsx" }, -- Optional: lazy-load for specific filetypes
}
