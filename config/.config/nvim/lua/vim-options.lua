vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.background = "light"
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false
vim.wo.number = true
vim.opt.splitright = true
vim.opt.relativenumber = true

-- Navigate vim panes better
vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

-- Remove search highlighting
vim.keymap.set("n", "<F3>", ":nohlsearch<CR>")

--Move lines
vim.keymap.set("n", "<A-k>", ":m-2<CR>")
vim.keymap.set("n", "<A-j>", ":m+<CR>")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")

-- Open file in finder
vim.keymap.set("n", "<leader>o", ":!open %<CR>")

-- Dismiss noice message panel
vim.keymap.set("n", "<Esc>", function()
  vim.cmd("Noice dismiss")
end, { desc = "Dismiss Noice messages" })

-- Use arrow keys inside of choice lists instead of tab
vim.api.nvim_set_keymap("c", "<Down>", 'v:lua.get_wildmenu_key("<right>", "<down>")', { expr = true })
vim.api.nvim_set_keymap("c", "<Up>", 'v:lua.get_wildmenu_key("<left>", "<up>")', { expr = true })
function _G.get_wildmenu_key(key_wildmenu, key_regular)
  return vim.fn.wildmenumode() ~= 0 and key_wildmenu or key_regular
end

-- Toggle virtual text hints
vim.api.nvim_create_user_command("ToggleHints", function()
  local current = vim.diagnostic.config().virtual_text
  vim.diagnostic.config({ virtual_text = not current })
  print("Virtual text: " .. (not current and "enabled" or "disabled"))
end, {})

-- Add line movements to jump list
vim.api.nvim_create_augroup("cursor_mark", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
  group = "cursor_mark",
  callback = function()
    vim.cmd("normal! m'")
  end,
  desc = "Mark current position when cursor is held",
})
