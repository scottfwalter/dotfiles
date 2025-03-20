return {
  {
    "echasnovski/mini.indentscope",
    version = false, -- Use the latest version
    event = { "BufReadPre", "BufNewFile" }, -- Load on these events
    opts = {
      -- Your configuration options here
      symbol = "│", -- Symbol used for the indentation guide
      options = { try_as_border = true },
    },
    config = function(_, opts)
      require("mini.indentscope").setup(opts)
    end,
  }
}

