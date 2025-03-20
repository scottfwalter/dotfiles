return {
  -- Your other plugins...

  {
    "voldikss/vim-floaterm",
    lazy = true,
    cmd = {"FloatermNew", "FloatermToggle", "FloatermPrev", "FloatermNext", "FloatermSend"},
    keys = {
      -- Optional: Add your keymaps here
      { "<leader>ft", "<cmd>FloatermToggle<CR>", desc = "Toggle terminal" },
    },
    config = function()
      -- Optional configuration
      vim.g.floaterm_width = 0.8
      vim.g.floaterm_height = 0.8
      vim.g.floaterm_position = "center"
    end,
  },

  {
    'akinsho/toggleterm.nvim',
     version = "*",
    keys = {
      -- Optional: Add your keymaps here
      { "<leader>fh", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
    },
     opts = {--[[ things you want to change go here]]}}

}

