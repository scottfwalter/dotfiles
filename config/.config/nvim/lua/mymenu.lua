-- Define the demo_select function
local function demo_select()
  local options = {
    "Execute Macro a",
    "Format File",
    "Github Copilot Chat",
    "Lazy Git",
    "Toggle Inline Hints",
  }
  local prompt = "Please select an option:"
  vim.ui.select(options, {
    prompt = prompt,
    format_item = function(item)
      return "→ " .. item
    end,
  }, function(choice)
    -- Execute different actions based on the selection
    if not choice then return end

    if choice:match("Lazy Git") then
      vim.cmd("LazyGit")
    elseif choice:match("Execute Macro a") then
      vim.cmd("normal! @a")
    elseif choice:match("Format File") then
      vim.cmd("normal! gg=G")
    elseif choice:match("Toggle Inline Hints") then
      vim.cmd("ToggleHints")
    elseif choice:match("Github Copilot Chat") then
      vim.cmd("CopilotChat")
    end
  end)
end

-- Register the custom command :scott
vim.api.nvim_create_user_command("Scott", function()
  demo_select()
end, {})

vim.keymap.set("n", "<leader>m", function()
  demo_select()
end, { desc = "My Menu" })
