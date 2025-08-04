--   - `opts.key_labels`: option is deprecated. see `opts.replace`
--   - `opts.window`: option is deprecated. see `opts.win`
--   - `opts.ignore_missing`: option is deprecated. see `opts.filter`
--   - `opts.triggers_blacklist`: option is deprecated. see `opts.triggers`
--   - `opts.operators`: option is deprecated. see `opts.defer`
--   - `opts.popup_mappings`: option is deprecated. see `opts.keys`
--   - `opts.triggers`: triggers must be a table
--   Please refer to the docs for more info.


return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
