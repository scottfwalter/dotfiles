return {
  {
    "mattn/emmet-vim",
    event = "VeryLazy",
    config = function()
      -- Enable only for specified file types
      vim.g.user_emmet_install_global = 0

      -- Enable for html, css, jsx, tsx files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
        command = "EmmetInstall",
      })

      -- Configure leader key for Emmet (default is <C-y>)
      vim.g.user_emmet_leader_key = "<C-y>"

      -- Optional: Enable JSX and TSX snippets in JS files
      vim.g.user_emmet_settings = {
        javascript = {
          extends = "jsx",
        },
        typescript = {
          extends = "tsx",
        },
      }
    end,
  }
}
