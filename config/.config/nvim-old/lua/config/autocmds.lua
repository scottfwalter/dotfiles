-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

--vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
--  pattern = { "*.md", "*.json", "*.mdx", "*.agx", "*.svx" },
--  callback = function()
--    vim.cmd("set conceallevel=0")
--  end,
--})
--
--vim.api.nvim_create_autocmd({ "BufLeave", "BufWinLeave" }, {
--  pattern = { "*.md", "*.json", "*.mdx", "*.agx", "*.svx" },
--  callback = function()
--    vim.cmd("set conceallevel=3")
--  end,
--})


