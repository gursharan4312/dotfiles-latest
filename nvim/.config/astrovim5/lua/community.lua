-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- ═══════════════════════════════════════════════════════════════
  -- LANGUAGE PACKS
  -- ═══════════════════════════════════════════════════════════════
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.typescript" }, -- Uses vtsls (faster than tsserver)
  { import = "astrocommunity.pack.json" }, -- ADD: JSON schema support (package.json, tsconfig, etc.)
  { import = "astrocommunity.pack.java" },
  -- { import = "astrocommunity.pack.go" },        -- REMOVE if you don't use Go

  -- Java config (UPDATE PATH FOR WSL/LINUX)
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-21",
                path = vim.fn.expand "~/.jenv/shims/java", -- Dynamic path
                -- Or use: "/usr/lib/jvm/java-21-openjdk-amd64"
              },
            },
          },
        },
        format = { enabled = true },
      },
    },
  },

  -- ═══════════════════════════════════════════════════════════════
  -- LSP ENHANCEMENTS
  -- ═══════════════════════════════════════════════════════════════
  { import = "astrocommunity.lsp.garbage-day-nvim" }, -- ADD: Stops inactive LSP clients (perf!)
  { import = "astrocommunity.lsp.ts-error-translator-nvim" }, -- ADD: Human-readable TS errors

  -- ═══════════════════════════════════════════════════════════════
  -- AI COMPLETION (COPILOT FIX)
  -- ═══════════════════════════════════════════════════════════════
  -- Option A: Use copilot-lua-cmp (bundled, simpler setup)
  { import = "astrocommunity.completion.copilot-lua-cmp" },
  -- Option B: If you use blink.cmp instead of nvim-cmp, use copilot-lua instead
  -- { import = "astrocommunity.completion.copilot-lua" },

  -- ═══════════════════════════════════════════════════════════════
  -- GIT
  -- ═══════════════════════════════════════════════════════════════
  { import = "astrocommunity.git.git-blame-nvim" },
  { import = "astrocommunity.git.diffview-nvim" },

  -- ═══════════════════════════════════════════════════════════════
  -- EDITING & UI
  -- ═══════════════════════════════════════════════════════════════
  { import = "astrocommunity.scrolling.vim-smoothie" },
  { import = "astrocommunity.indent.indent-tools-nvim" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.bars-and-lines.lualine-nvim" },
  { import = "astrocommunity.bars-and-lines.vim-illuminate" },

  -- ═══════════════════════════════════════════════════════════════
  -- TERMINAL
  -- ═══════════════════════════════════════════════════════════════
  { import = "astrocommunity.terminal-integration.flatten-nvim" },
}
