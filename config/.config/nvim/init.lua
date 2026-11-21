-- OPTIONS
vim.g.mapleader = " "
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.scriptencoding = "utf-8"

-- tab spacing
vim.opt.cindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- numbers on the left
vim.opt.relativenumber = true
vim.opt.number = true

-- turn to false if not worried about "losing" code
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.clipboard = ""
vim.opt.diffopt:append("iwhite")
vim.opt.diffopt:append("algorithm:histogram")
vim.opt.diffopt:append("indent-heuristic")
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.title = true

-- colors
vim.g.vim_default_colors = 1
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd([[colorscheme retrobox]])
vim.cmd([[highlight Normal guibg=none]])
vim.cmd([[highlight NonText guibg=none]])

vim.opt.updatetime = 250
vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes"
vim.opt.list = false -- disables the angular brackets for tabs
vim.opt.scrolloff = 8
vim.opt.mouse = "a" -- allow for mouse scroll

vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.cursorline = true

vim.opt.inccommand = "split"
vim.opt.smoothscroll = true
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.title = true
vim.opt.listchars = "tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•"
vim.opt.smartcase = true
vim.opt.ignorecase = true -- case insensitive search
vim.opt.completeopt = {
	"menu",
	"menuone",
	"noselect",
	"noinsert",
} -- better completion
vim.opt.pumheight = 100 -- limit completion items
vim.showcmd = true

-- search
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

vim.filetype.add({
  extension = {
    h = "c",
    hpp = "cpp",
  },
})

-- KEYMAPS
local opts = { noremap = true, silent = true }

-- Tabs
vim.keymap.set("n", "<tab>", ":tabnext<Return>", opts)
vim.keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)

-- yank to clipboard
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>yy", '"+yy')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set("x", "<leader>y", '"+y')
vim.keymap.set("x", "<leader>Y", '"+Y')

-- Move selected text up or down
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")

-- delete, not cut
vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("x", "<leader>d", '"_d')

-- <C-a> is my global leader for tmux - increments
vim.keymap.set("n", "<C-a>", "<nop>")
vim.keymap.set("v", "<C-a>", "<nop>")
vim.keymap.set("n", "<C-Z>", "<nop>")
vim.keymap.set("n", "<C-Z>", "<C-A>")
vim.keymap.set("v", "<C-Z>", "<nop>")
vim.keymap.set("v", "<C-Z>", "<C-A>")

-- highlights yanks
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup
local yank_group = augroup("HighlightYank", {})
autocmd("TextYankPost", {
	group = yank_group,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 250,
		})
	end,
})

-- go to last loc when opening a buffer
local function augroup(name)
	return vim.api.nvim_create_augroup(name, { clear = true })
end
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup("jump_to_last_loc"),
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	group = augroup("auto_create_dir"),
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Lazy package manager
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

vim.g.mapleader = " "

-- Plugins
require("lazy").setup({
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			{
				"L3MON4D3/LuaSnip",
				lazy = true,
			},
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					-- REQUIRED by nvim-cmp. get rid of it once we can
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					-- Accept currently selected item.
					-- Set `select` to `false` to only confirm explicitly selected items.
					["<CR>"] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
				}, {
					{ name = "path" },
				}),
				experimental = {
					ghost_text = true,
				},
			})

			-- Enable completing paths in :
			cmp.setup.cmdline(":", {
				sources = cmp.config.sources({
					{ name = "path" },
				}),
			})
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			-- Get signatures (and _only_ signatures) when in argument lists.
			require("lsp_signature").setup({
				doc_lines = 0,
				handler_opts = {
					border = "none",
				},
			})
		end,
	},
	-- "github/copilot.vim",
	{
		"andymass/vim-matchup",
		ft = { "tex" },
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
			vim.g.matchup_matchparen_enabled = 1 -- 0 to disable highligts
		end,
	},
	{
		"echasnovski/mini.surround",
		version = false,
		config = function()
			local surround = require("mini.surround")
			surround.setup({
				mappings = {
					add = "sa", -- Add surrounding in Normal and Visual modes
					delete = "sd", -- Delete surrounding

					find = "sf", -- Find surrounding (to the right)
					find_left = "sF", -- Find surrounding (to the left)

					highlight = "sH", -- Highlight surrounding
					replace = "sr", -- Replace surrounding

					update_n_lines = "sn", -- Update `n_lines`

					suffix_last = "l", -- Suffix to search with "prev" method
					suffix_next = "n", -- Suffix to search with "next" method
				},
			})
		end,
	},
	{
		"ibhagwan/fzf-lua",
		config = function()
			-- stop putting a giant window over my editor
			require("fzf-lua").setup({
				winopts = {
					preview = {
						hidden = true,
					},
				},
				files = {
					file_icons = false,
					git_icons = true,
					_fzf_nth_devicons = true,
				},
				buffers = {
					file_icons = true,
					git_icons = true,
				},
				fzf_opts = {
					-- no reverse view
					["--layout"] = "default",
				},
				keymap = {
					-- File picker
					vim.keymap.set("n", "<leader>ff", ":FzfLua files<CR>"),
					-- Grep
					vim.keymap.set("n", "<leader>/", ":FzfLua grep_project<CR>"),
					-- Git
					vim.keymap.set("n", "<leader>fg", ":FzfLua git_files<CR>"),
					-- Undo tree
					vim.keymap.set("n", "<leader>u", function()
						FzfLua.undotree({
							winopts = { preview = { hidden = false } },
						})
					end),
				},
			})
		end,
	},
    {
		'neovim/nvim-lspconfig',
		config = function()
			-- Setup language servers.

			-- Rust
			vim.lsp.config["rust-analyzer"] = {
                cargo = {
                    features = "all",
                },
                checkOnSave = {
                    enable = true,
                },
                check = {
                    command = "clippy",
                },
                imports = {
                    group = {
                        enable = false,
                    },
                },
                completion = {
                    postfix = {
                        enable = false,
                    },
                },
            }
			vim.lsp.enable('rust_analyzer')

			-- Bash LSP
			if vim.fn.executable('bash-language-server') == 1 then
				vim.lsp.enable('bash-language-server')
			end

			-- texlab for LaTeX
			if vim.fn.executable('texlab') == 1 then
				vim.lsp.enable('texlab')
			end

			-- Ruff for Python
			if vim.fn.executable('ruff') == 1 then
				vim.lsp.enable('ruff')
			end

            -- BasedPyrigt for Python
			if vim.fn.executable('basedpyright') == 1 then
				vim.lsp.enable('basedpyright')
			end

            -- Clangd for C/C++
            vim.lsp.config["clangd"] = {
                filetypes = { "c", "h", "cpp" },
                cmd = { "clangd", "--fallback-style=webkit" },
                single_file_support = true,
            }
            vim.lsp.enable('clangd')

			-- nil for nix
			if vim.fn.executable('nil') == 1 then
				vim.lsp.enable('nil_ls')
			end

			-- Global mappings.
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.keymap.set('n', '<leader>gg', vim.diagnostic.open_float)
			vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
			vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
			vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

					-- Buffer local mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
					vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
					vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
					vim.keymap.set({ 'n', 'v' }, '<leader>ga', vim.lsp.buf.code_action, opts)
					vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, opts)
					vim.keymap.set('n', '<leader>F', function()
						vim.lsp.buf.format { async = true }
					end, opts)

					local client = vim.lsp.get_client_by_id(ev.data.client_id)

					-- TODO: find some way to make this only apply to the current line.
					if client.server_capabilities.inlayHintProvider then
					    vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
					end

					-- None of this semantics tokens business.
					-- https://www.reddit.com/r/neovim/comments/143efmd/is_it_possible_to_disable_treesitter_completely/
					client.server_capabilities.semanticTokensProvider = nil

					-- format on save for Rust
					if client.server_capabilities.documentFormattingProvider then
						vim.api.nvim_create_autocmd("BufWritePre", {
							group = vim.api.nvim_create_augroup("RustFormat", { clear = true }),
							buffer = bufnr,
							callback = function()
								vim.lsp.buf.format({ bufnr = bufnr })
							end,
						})
					end
				end,
			})
		end
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
	-- LaTex
	{
		"lervag/vimtex",
		ft = "tex",
		lazy = false, -- we don't want to lazy load VimTeX
		init = function()
			vim.g.vimtex_view_method = "zathura"

			vim.g.vimtex_compiler_latexmk = {
				options = {
					"-shell-escape",
					"-verbose",
					"-file-line-error",
					"-interaction=nonstopmode",
					"-synctex=1",
					-- "-recorder"
				},
			}
		end,
	},
	{
		"shortcuts/no-neck-pain.nvim",
		version = "*",
		opts = {
			mappings = {
				enabled = true,
				toggle = false,
				toggleLeftSide = false,
				toggleRightSide = false,
				widthUp = false,
				widthDown = false,
				scratchPad = false,
			},
		},
		config = function()
			vim.keymap.set("", "<leader>..", function()
				vim.cmd([[
					:NoNeckPain
					:set formatoptions-=tc linebreak tw=0 cc=0 wrap wm=20 noautoindent nocindent nosmartindent indentkeys=
				]])
				-- make 0, ^ and $ behave better in wrapped text
				vim.keymap.set("n", "0", "g0")
				vim.keymap.set("n", "$", "g$")
				vim.keymap.set("n", "^", "g^")
			end)
		end,
	},
    { "nvim-tree/nvim-web-devicons" },
})
