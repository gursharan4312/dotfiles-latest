return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "default", -- Keep the default LazyVim mappings
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
      },
      completion = {
        list = {
          selection = { preselect = false, auto_insert = true },
        },
      },
    },
  },
}
