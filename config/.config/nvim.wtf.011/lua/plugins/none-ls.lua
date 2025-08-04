return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
  },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        -- Formatting sources
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.rubocop,

        --require("none-ls.diagnostics.eslint"),

        -- Diagnostic sources - using none-ls-extras for better 0.11 compatibility
        --require("none-ls.diagnostics.eslint_d"),
        --null_ls.builtins.diagnostics.rubocop,

        --null_ls.builtins.diagnostics.eslint, -- Use built-in instead of none-ls-extras
        null_ls.builtins.diagnostics.rubocop,
      },
      -- Ensure compatibility with Neovim 0.11 diagnostic system
      diagnostics_format = "#{m}",
      update_in_insert = false,
    })
    --
    --     -- Format on save with error handling
    --     vim.api.nvim_create_autocmd("BufWritePre", {
    --       pattern = "*",
    --       callback = function()
    --         pcall(function()
    --           vim.lsp.buf.format({
    --             async = false,
    --             timeout_ms = 2000,
    --             filter = function(client)
    --               return client.name == "null-ls"
    --             end
    --           })
    --         end)
    --       end,
    --     })
    --
    --     -- Manual format keymap with error handling
    --     vim.keymap.set("n", "<leader>gf", function()
    --       pcall(function()
    --         vim.lsp.buf.format({
    --           async = true,
    --           filter = function(client)
    --             return client.name == "null-ls"
    --           end
    --         })
    --       end)
    --     end, { desc = "Format buffer" })
  end,
}
