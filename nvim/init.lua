-- Behavior settongs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.modeline = true
vim.opt.modelines = 5
vim.opt.formatoptions:append('r')
vim.opt.wildmenu = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.mouse = 'nvicr'
vim.opt.scrolloff = 0
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/state/undo"
vim.cmd('filetype plugin on')
vim.g.mapleader = ' '
vim.keymap.set('n', '<Leader>y', '"+y')
vim.keymap.set('n', '<Leader>p', '"+p')
vim.keymap.set('n', '<ScrollWheelUp>', '<C-Y>')
vim.keymap.set('n', '<ScrollWheelDown>', '<C-E>')

-- Looks settings
vim.cmd("syntax on")
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 1
vim.opt.conceallevel = 2
vim.opt.showmode = false
vim.opt.laststatus = 2

-- Fold settings
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevel = 30

-- spell settings
vim.opt.spelllang = 'custom,he,en'
vim.opt.spellcapcheck = ''
vim.opt.spell = true

-- Auto commands groups settings
local specialsgroup = vim.api.nvim_create_augroup('specials', { clear = true })
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
	pattern = '*/.config/sway/*',
	group = specialsgroup,
	command = 'silent !swaymsg reload',
})
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
	pattern = '*.rasi',
	group = specialsgroup,
	command = 'set syntax=css',
})

vim.g.vimtex_syntax_enabled = 0
vim.g.vimtex_syntax_conceal_disable = 1

-- Lazy nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local lazy_plugins = {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = true,
		opts = {
			transparent_background = true,
			flavour = "macchiato"
		}
	},
	{ "lewis6991/gitsigns.nvim", opts = {} },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { 'nvim-tree/nvim-web-devicons', 'AndreM222/copilot-lualine' },
		opts = {
			options = {
				theme = 'auto',
				component_separators = '',
				section_separators = { left = '', right = '' },
			},
			sections = {
				lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
				lualine_b = { 'filename', 'branch', 'diff', 'diagnostics' },
				lualine_c = {
					'%=', --[[ add your center compoentnts here in place of this comment ]]
				},
				lualine_x = {},
				lualine_y = { 'copilot', 'filetype', 'progress' },
				lualine_z = {
					{ 'location', separator = { right = '' }, left_padding = 2 },
				},
			},
			inactive_sections = {
				lualine_a = { 'filename' },
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = { 'location' },
			},
			tabline = {},
			extensions = {},
		}
	},
	{
		"preservim/vim-pencil",
		ft = { "text" },
		lazy = true,
		config = function()
			vim.cmd("call pencil#init()")
		end
	},
	{
		"f-person/auto-dark-mode.nvim",
		config = {
			update_interval = 1000,
			set_dark_mode = function()
				vim.opt.background = 'dark'
				vim.cmd("colorscheme catppuccin-macchiato")
			end,
			set_light_mode = function()
				vim.opt.background = 'light'
				vim.cmd("colorscheme gruvbox-latte")
			end,
		},
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup {
				filetypes = {
					["*"] = false,
				}
			}
		end,
	},
	"nvim-treesitter/nvim-treesitter",
	"hrsh7th/cmp-nvim-lsp",
	"saadparwaiz1/cmp_luasnip",
	"rafamadriz/friendly-snippets",
	"L3MON4D3/LuaSnip",
	"hrsh7th/nvim-cmp",
	"neovim/nvim-lspconfig",
	"tpope/vim-fugitive",
	"lervag/vimtex"
}
require("lazy").setup(lazy_plugins)
require('nvim-treesitter.configs').setup {
	auto_install = true,
	highlight = {
		enable = true
	},
	incremental_selection = {
		enable = true
	},
	indent = {
		enable = true
	}
}

-- Theme
vim.o.background = 'dark'
vim.cmd("colorscheme catppuccin")

-- Mappings.
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local on_attach = function(_, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

require('lspconfig').lua_ls.setup {
	on_attach = on_attach,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	on_init = function(client)
		local path = client.workspace_folders[1].name
		if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
			return
		end

		client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using
				-- (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT'
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME
					-- Depending on the usage, you might want to add additional paths here.
					-- "${3rd}/luv/library"
					-- "${3rd}/busted/library",
				}
				-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
				-- library = vim.api.nvim_get_runtime_file("", true)
			}
		})
	end,
	settings = {
		Lua = {}
	}
}

require('lspconfig').pylsp.setup {
	on_attach = on_attach,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = {
					ignore = { 'W391' },
					maxLineLength = 100
				}
			}
		}
	}
}

require('lspconfig').texlab.setup {
	on_attach = on_attach,
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
	settings = {
		["texlab"] = {
			auxDirectory = "./bin/",
			build = {
				executable = "latexmk",
				args = { "-lualatex", "-interaction=nonstopmode", "-synctex=1", '-output-directory=./bin/', "%f" },
				forwardSearchAfter = false,
				onSave = true
			},
			forwardSearch = {
				executable = "zathura",
				args = { "--synctex-editor-command=nvim --server '" .. vim.v['servername'] .. "' --remote-send %%{line}G", "--synctex-forward", "%l:1:%f", "%p" }
			},
			chktex = {
				onOpenAndSave = true,
				onEdit = true,
			}
		}
	}
}

local cmp = require('cmp')
cmp.setup {
	sources = {
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' }
	},
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered()
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true })
	})
}

local ls = require('luasnip')
vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-L>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-J>", function() ls.jump(-1) end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, { silent = true })
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/.config/nvim/snippets" } })
