  return {
    "ray-x/navigator.lua",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter", -- Optional but recommended
    },
    config = function()
      require("navigator").setup({
        -- Your configuration options here
      })
    end
  }
