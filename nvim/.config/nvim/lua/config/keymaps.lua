-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

-- Copy Relative Path
vim.keymap.set("n", "<leader>fy", function()
  -- ":." makes it relative to the current working directory
  local path = vim.fn.fnamemodify(vim.fn.expand("%"), ":.")
  vim.fn.setreg("+", path)
  vim.notify("Copied relative path: " .. path)
end, { desc = "Copy Relative Path" })

-- Copy Absolute Path
vim.keymap.set("n", "<leader>fY", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied absolute path: " .. path)
end, { desc = "Copy Absolute Path" })

-- Show the full diagnostic message for the current line.
vim.keymap.set("n", "E", function()
  vim.diagnostic.open_float(nil, {
    border = "rounded",
    focusable = true,
    scope = "line",
  })
end, { desc = "Show Line Diagnostic" })

-- Toggle comment with <leader>/
-- vim.keymap.set("n", "<leader>/", "gcc", { desc = "Toggle comment line", remap = true })
-- vim.keymap.set("x", "<leader>/", "gc", { desc = "Toggle comment", remap = true })
