-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.g.root_spec = { "cwd" }

-- Prevent Neovim (and the LSP) from watching massive build artifacts
vim.opt.wildignore:append({ "**/node_modules/**", "**/dist/**", "**/.git/**", "**/build/**" })
