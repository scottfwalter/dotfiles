return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "eslint", "emmet_language_server", "angularls", "html" },
        --ensure_installed = { "lua_ls", "vtsls", "eslint", "emmet_language_server", "angularls", "html" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local lspconfig = require("lspconfig")
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })
      lspconfig.solargraph.setup({
        capabilities = capabilities,
      })
      lspconfig.html.setup({
        capabilities = capabilities,
      })
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim", "Snacks" },
            },
            -- workspace = {
            --   library = vim.api.nvim_get_runtime_file("", true),
            --   checkThirdParty = false,
            -- },
          },
        },
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

      lspconfig.emmet_language_server.setup({
        filetypes = {
          "astro",
          "css",
          "eruby",
          "html",
          "javascript",
          "javascriptreact",
          "less",
          "php",
          "pug",
          "sass",
          "scss",
          "typescriptreact",
        },
        init_options = {
          html = {
            options = {
              ["bem.enabled"] = true,
            },
          },
        },
      })
    end,
  },
}
