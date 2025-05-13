-- Add this to your init.lua file or create a file in lua/plugins/

-- Function to open a floating window with file contents
function open_file_in_float(filename)
  -- Get file content
  local lines = vim.fn.readfile(filename)

  -- Calculate window size and position
  local width = math.min(80, vim.o.columns - 4)
  local height = math.min(20, vim.o.lines - 4)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Window options
  local buf = vim.api.nvim_create_buf(false, true)
  local opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded"
  }

  -- Set buffer contents
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Open the window
  --local win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_open_win(buf, true, opts)

  -- Close window with 'q' key
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", {noremap = true, silent = true})
end

-- Define a keybinding to open a specific file
vim.keymap.set("n", "<leader>h", function()
  -- Change this to your desired file path
  open_file_in_float(vim.fn.expand("~/.config/nvim/help.txt"))
end, {desc = "Show My NeoVim Help"})

-- Alternatively, to open the current file in a floating preview
vim.keymap.set("n", "<leader>fp", function()
  open_file_in_float(vim.fn.expand("%:p"))
end, {desc = "Preview current file in float"})

