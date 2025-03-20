vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.g.background = "light"

vim.opt.swapfile = false

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.wo.number = true

--vim.imap ,, <C-y>,
--vim.keymap.set('i',',,','<c-y>,')
--vim.inoremap ,, <C-y>,
--vim.api.nvim_set_keymap('i', ',,', '<C-y>,', { noremap = true })
--vim.keymap.set('i', ',.', '<C-y>,')

vim.keymap.set('n', '<Esc>', function() vim.cmd('Noice dismiss') end, { desc = 'Dismiss Noice messages' })
