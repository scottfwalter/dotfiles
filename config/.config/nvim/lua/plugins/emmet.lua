--return {
--"olrtg/nvim-emmet",
--  config = function()
--    vim.keymap.set({ "n", "v" }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
--  end,
--}

return {
  -- Your other plugins...

  {
    "mattn/emmet-vim",
    ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "php" },
    config = function()
      -- Optional: Configure Emmet settings
      vim.g.user_emmet_leader_key = 'C-y' -- Default leader key
      -- vim.g.user_emmet_settings = { ... } -- Optional custom settings
    end,
  },

  -- More plugins...
}
