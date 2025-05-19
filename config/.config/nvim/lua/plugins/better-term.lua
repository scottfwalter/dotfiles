return {
  "CRAG666/betterTerm.nvim",
  opts = {
    position = "bot",
    size = 15,
    jump_tab_mapping = "<A-$tab>"
  },
  keys = {
    {
      mode = { 'n', 't' },
      --'<leader>h',
      '<C-t>',
      function()
        require('betterTerm').open()
      end,
      desc = 'Open BetterTerm 0',
    },
    -- {
    --   mode = { 'n', 't' },
    --   '<C-/>',
    --   function()
    --     require('betterTerm').open(1)
    --   end,
    --   desc = 'Open BetterTerm 1',
    -- },
    {
      '<leader>tt',
      function()
        require('betterTerm').select()
      end,
      desc = 'Select terminal',
    }
  },
}
