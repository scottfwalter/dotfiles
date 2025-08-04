
return {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons', -- Only needed if you want devicons
    config = function()
      require("bufferline").setup({
        -- Your configuration options here
        options = {
          -- For example:
          mode = "buffers", -- set to "tabs" to only show tabpages instead
          numbers = "none", -- can be "none" | "ordinal" | "buffer_id" | "both"
          close_command = "bdelete! %d", -- can be a string | function
          indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
            style = 'icon', -- can also be 'underline'|'none',
          },
          buffer_close_icon = '󰅖',
          modified_icon = '●',
          close_icon = '',
          left_trunc_marker = '',
          right_trunc_marker = '',
          max_name_length = 18,
          max_prefix_length = 15,
          tab_size = 18,
          diagnostics = "nvim_lsp", -- false | "nvim_lsp" | "coc"
          show_buffer_icons = true,
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          persist_buffer_sort = true,
          separator_style = "thin", -- "slant" | "thick" | "thin" | { 'any', 'any' }
          enforce_regular_tabs = false,
          always_show_bufferline = true,
        }
      })
    end,
  }
