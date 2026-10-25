-- Disable vtsls so only tsgo attaches to TS/JS files.
-- To re-enable vtsls, set `enabled = true` (and optionally restore the settings below).
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = { enabled = false },
      },
    },
  },
}

-- Previous vtsls customization (kept for reference):
--
-- return {
--   {
--     "neovim/nvim-lspconfig",
--     opts = {
--       servers = {
--         vtsls = {
--           cmd = { "vtsls", "--stdio", "--max-old-space-size=8192" },
--           settings = {
--             typescript = {
--               tsserver = {
--                 maxTsServerMemory = 8192,
--               },
--             },
--             vtsls = {
--               experimental = {
--                 completion = {
--                   enableServerSideFuzzyMatch = true,
--                 },
--               },
--             },
--           },
--         },
--       },
--     },
--   },
-- }
