 return {
    'echasnovski/mini.nvim',
    version = false, -- Use the latest version
    config = function()
      -- Load and configure mini.pairs
      require('mini.pairs').setup({
        -- You can customize the pairs configuration here
        -- For example:
        -- mappings = {
        --   ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
        --   ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
        -- },
      })
    end,
  }
