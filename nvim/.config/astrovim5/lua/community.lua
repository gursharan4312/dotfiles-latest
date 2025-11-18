-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.java" },
  -- { import = "astrocommunity.lsp.nvim-java" },
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      settings = {
        java = {
          configuration = {
            runtimes = {
              {
                name = "JavaSE-21",
                path = "/Users/gursharan.singh/.jenv/shims/java",
              },
            },
          },
        },
        format = {
          enabled = true,
          -- settings = { -- you can use your preferred format style
          --   url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml",
          --   profile = "GoogleStyle",
          -- },
        },
      },
    },
  },

  { import = "astrocommunity.completion.copilot-cmp" },

  { import = "astrocommunity.git.git-blame-nvim" },
  { import = "astrocommunity.git.diffview-nvim" },

  { import = "astrocommunity.scrolling.vim-smoothie" },
  { import = "astrocommunity.indent.indent-tools-nvim" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  -- { import = "astrocommunity.colorscheme.tokyonight-nvim" },
  -- { import = "astrocommunity.bars-and-lines.dropbar-nvim" },
  { import = "astrocommunity.bars-and-lines.lualine-nvim" }, -- bottom status bar line
  { import = "astrocommunity.bars-and-lines.vim-illuminate" }, -- highlight selected word

  { import = "astrocommunity.terminal-integration.flatten-nvim" }, -- open files in current vim from terminal
  -- import/override with your plugins folder
}
