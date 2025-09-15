vim.g.mapleader = " "

vim.pack.add({
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/saghen/blink.cmp",            version = vim.version.range("^1") },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/folke/snacks.nvim" },


    { src = "https://github.com/m4xshen/hardtime.nvim" },
    { src = "https://github.com/tris203/precognition.nvim" },

    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate" },
})


require("hardtime").setup()
require("precognition").toggle()

require('mason').setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
    ensure_installed = {
        "lua_ls"
    }
})

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc",
    "query",
    "javascript",
    "html",
    "css",
    "json",
    "python",
    "c"
  },

  sync_install = false,   -- install parsers async
  auto_install = true,    -- auto install missing parsers on buffer open

  highlight = {
    enable = true,        -- enable tree-sitter based highlighting
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,        -- experimental tree-sitter indentation
  },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function() vim.treesitter.start() end,
})

require("gitsigns").setup({ 
    current_line_blame = true 
})

require("snacks").setup({
    bigfile = { enable = true },
    indent = { enable = true },
    quickfile = { enabled = true },
    notifier = { enabled = true },
    scroll = { enabled = true },
    words = { enabled = true },
    input = { enabled = true },
    lazygit = { enabled = true },
})

vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			diagnostics = {
				globals = {
					'vim',
					'require'
				},
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

require("oil").setup({
    float = {
        padding = 2,
        max_width = 100,
        max_height = 30,
        border = "rounded",
    },
    keymaps = {
        ["q"]    = "actions.close",
    }
})

vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
require('blink.cmp').setup({
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true },
    keymap = { preset = 'default' },
    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "normal",
    },

    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        }
    },

    cmdline = {
        keymap = {
            preset = 'inherit',
            ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },
    },
    sources = { default = { "lsp" } }
})

local actions = require('fzf-lua.actions')
require('fzf-lua').setup({
    winopts = {
        height = 1,
        width = 1,
        backdrop = 85,
        preview = {
            horizontal = "right:70%",
        }
    },
    keymap = {
        builtin = {
            ["<C-f>"] = "preview-page-down",
            ["<C-b>"] = "preview-page-up",
            ["<C-p>"] = "toggle-preview",
        },
        fzf = {
            ["ctrl-a"] = "toggle-all",
            ["ctrl-t"] = "first",
            ["ctrl-g"] = "last",
            ["ctrl-d"] = "half-page-down",
            ["ctrl-u"] = "half-page-up",
        }
    },
    actions = {
        files = {
            ["ctrl-q"] = actions.file_sel_to_qf,
            ["ctrl-n"] = actions.toggle_ignore,
            ["ctrl-h"] = actions.toggle_hidden,
            ["enter"]  = actions.file_edit_or_qf,
        }
    }
})


vim.g.vimtex_imaps_enabled = 0
vim.g.vimtex_view_method = "skim"
vim.g.latex_view_general_viewer = "skim"
vim.g.latex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_quickfix_open_on_warning = 0
vim.g.vimtex_quickfix_ignore_filters = { "Underfull", "Overfull", "LaTeX Warning: .\\+ float specifier changed to",
    "Package hyperref Warning: Token not allowed in a PDF string" }
