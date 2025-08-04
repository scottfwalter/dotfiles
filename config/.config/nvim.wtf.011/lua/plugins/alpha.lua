-- return {
--   "goolord/alpha-nvim",
--   dependencies = {
--     "nvim-tree/nvim-web-devicons",
--   },
--
--   config = function()
--     local alpha = require("alpha")
--     local dashboard = require("alpha.themes.startify")
--
--     dashboard.section.header.val = {
--       [[                                                                       ]],
--       [[                                                                       ]],
--       [[                                                                       ]],
--       [[                                                                       ]],
--       [[                                                                     ]],
--       [[       ████ ██████           █████      ██                     ]],
--       [[      ███████████             █████                             ]],
--       [[      █████████ ███████████████████ ███   ███████████   ]],
--       [[     █████████  ███    █████████████ █████ ██████████████   ]],
--       [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
--       [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
--       [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
--       [[                                                                       ]],
--       [[                                                                       ]],
--       [[                                                                       ]],
--     }
--
--     alpha.setup(dashboard.opts)
--   end,
-- }

return {
  'goolord/alpha-nvim',
  dependencies = { 'echasnovski/mini.icons' },
  config = function()
    require 'alpha'.setup(require 'alpha.themes.startify'.config)
  end
};

-- return {
--   'goolord/alpha-nvim',
--   config = function()
--     require 'alpha'.setup(require 'alpha.themes.dashboard'.config)
--   end
-- };
