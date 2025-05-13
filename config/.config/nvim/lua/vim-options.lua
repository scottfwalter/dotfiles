vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.clipboard = "unnamedplus"

vim.opt.swapfile = false

-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

vim.keymap.set("n", "<F3>", ":nohlsearch<CR>")

--Move single lines
vim.keymap.set("n", "<A-k>", ":m-2<CR>")
vim.keymap.set("n", "<A-j>", ":m+<CR>")

-- Move multiple lines in visual mode
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
--vnoremap <A-k> :m '<-2<CR>gv=gv
--vnoremap <A-j> :m '>+1<CR>gv=gvars

vim.wo.number = true

--vim.imap ,, <C-y>,
--vim.keymap.set('i',',,','<c-y>,')
--vim.inoremap ,, <C-y>,
--vim.api.nvim_set_keymap('i', ',,', '<C-y>,', { noremap = true })
--vim.keymap.set('i', ',.', '<C-y>,')

vim.keymap.set("n", "<Esc>", function()
  vim.cmd("Noice dismiss")
end, { desc = "Dismiss Noice messages" })

vim.keymap.set("n", "<leader>o", ":!open %<CR>")

local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
vim.api.nvim_create_augroup("JSLogMacro", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "JSLogMacro",
  pattern = { "javascript", "typescript" },
  callback = function()
    vim.fn.setreg("l", "yoconsole.log('" .. esc .. "pa:" .. esc .. "la, " .. esc .. "pl")
  end,
})

vim.api.nvim_set_keymap("c", "<Down>", 'v:lua.get_wildmenu_key("<right>", "<down>")', { expr = true })
vim.api.nvim_set_keymap("c", "<Up>", 'v:lua.get_wildmenu_key("<left>", "<up>")', { expr = true })

function _G.get_wildmenu_key(key_wildmenu, key_regular)
  return vim.fn.wildmenumode() ~= 0 and key_wildmenu or key_regular
end

local macro_group = vim.api.nvim_create_augroup("macro", { clear = true })
local cursorline = nil

-- vim.api.nvim_create_autocmd("RecordingEnter", {
--   group = macro_group,
--   callback = function()
--     --local palette = require("catppuccin.palettes").get_palette("mocha")
--
--     cursorline = vim.api.nvim_get_hl(0, { name = "CursorLine" })
--     --vim.api.nvim_set_hl(0, "CursorLine", { bg = palette.maroon, fg = palette.crust })
--     vim.api.nvim_set_hl(0, "CursorLine", {
--       bg = "#f0e6d2",
--       fg = "#000000",
--       bold = true,
--     })
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("RecordingLeave", {
--   group = macro_group,
--   callback = function()
--     if cursorline ~= nil then
--       vim.api.nvim_set_hl(0, "CursorLine", cursorline)
--     end
--   end,
-- })
--
vim.o.showmode = true

vim.api.nvim_create_autocmd("RecordingEnter", {
  pattern = "*",
  callback = function()
    vim.cmd("redrawstatus")
  end,
})

-- Autocmd to track the end of macro recording
vim.api.nvim_create_autocmd("RecordingLeave", {
  pattern = "*",
  callback = function()
    vim.cmd("redrawstatus")
  end,
})

vim.api.nvim_create_user_command("ToggleHints", function()
  local current = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not current })
  print("Virtual text: " .. (not current and "enabled" or "disabled"))
end, {})
vim.opt.splitright = true

vim.opt.relativenumber = true

vim.api.nvim_create_augroup("cursor_mark", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
  group = "cursor_mark",
  callback = function()
    vim.cmd("normal! m'")
  end,
  desc = "Mark current position when cursor is held"
})
