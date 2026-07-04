-- ### VIM SETTINGS ### --

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = false
vim.opt.wrap = false
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.signcolumn = "yes" -- always display to prevent shifting
vim.opt.undofile = true    -- save undo history

vim.opt.termguicolors = true

vim.opt.guicursor = "n-v-c:block-blinkon0,i-ci-ve:ver25-blinkwait200-blinkon200-blinkoff200"

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = "⇀ ", trail = "·", nbsp = "␣" }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable unused providers (silences healthcheck noise)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- ### lazy.nvim ### --

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- COLOR SCHEMES --
		{
			"mcncl/alabaster.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				require("alabaster").setup({
					style = "dark",
					transparent = true,
				})
				vim.cmd.colorscheme("alabaster")
			end,
		},
		--------------------------------------------------------
		{
			"folke/which-key.nvim",
		},
		{
			"nullromo/go-up.nvim",
			opts = {},
			config = function(_, opts)
				local goUp = require("go-up")
				goUp.setup(opts)
			end,
		},
		{
			"christoomey/vim-tmux-navigator",
			cmd = {
				"TmuxNavigateLeft",
				"TmuxNavigateDown",
				"TmuxNavigateUp",
				"TmuxNavigateRight",
				"TmuxNavigatePrevious",
				"TmuxNavigatorProcessList",
			},
			keys = {
				{ "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
				{ "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
				{ "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
				{ "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
				{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
			},
		},
		{
			-- when using :46 (e.g.) temporarily jumps to line 46, but back on <Esc>
			"nacro90/numb.nvim",
			event = "BufRead",
			config = function()
				require("numb").setup({
					show_numbers = true,
					show_cursorline = true,
				})
			end,
		},
		{
			"rachartier/tiny-inline-diagnostic.nvim",
			event = "LspAttach",
			priority = 1000,
			config = function()
				vim.diagnostic.config({ virtual_text = false })
				require("tiny-inline-diagnostic").setup({
					preset = "simple",
					options = {
						show_source = true,
						multiple_diag_under_cursor = true,
						break_line = {
							enabled = true,
							after = 40,
						},
					},
				})
			end,
		},
		{
			"ThePrimeagen/harpoon",
			branch = "harpoon2",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
		{
			"nvim-telescope/telescope.nvim",
			tag = "v0.2.1",
			dependencies = {
				{ "nvim-lua/plenary.nvim" },
				{
					"nvim-telescope/telescope-fzf-native.nvim",
					build = "make",
					cond = function()
						return vim.fn.executable("make") == 1
					end,
				},
				{ "nvim-telescope/telescope-ui-select.nvim" },
				{ "nvim-tree/nvim-web-devicons" },
			},
			config = function()
				local telescope = require("telescope")
				telescope.setup({
					defaults = {
						layout_strategy = "horizontal",
						layout_config = {
							prompt_position = "top",
						},
						sorting_strategy = "ascending",
					},
					extensions = {
						["ui-select"] = {
							require("telescope.themes").get_dropdown({}),
						},
					},
					pickers = {
						find_files = {
							hidden = true,
							file_ignore_patterns = {
								".git",
							},
						},
					},
				})

				telescope.load_extension("ui-select")
				telescope.load_extension("fzf")
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			lazy = false,
			init = function()
				local ensure_installed = {
					"lua",
					"javascript",
					"typescript",
					"html",
					"css",
					"json",
					"tmux",
					"yaml",
					"markdown",
					"markdown_inline",
					"regex",
					"bash",
				}
				local installed = require("nvim-treesitter.config").get_installed()
				local to_install = vim.iter(ensure_installed)
						:filter(function(parser)
							return not vim.tbl_contains(installed, parser)
						end)
						:totable()
				if #to_install > 0 then
					require("nvim-treesitter").install(to_install)
				end

				vim.api.nvim_create_autocmd("FileType", {
					callback = function()
						pcall(vim.treesitter.start)
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end,
				})
			end,
		},
		{
			"numToStr/Comment.nvim",
		},
		{
			"folke/todo-comments.nvim",
			event = "VimEnter",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
			opts = { signs = false },
		},
		{
			"akinsho/bufferline.nvim",
			version = "*",
			config = function()
				local bufferline = require("bufferline")
				bufferline.setup({
					highlights = {
						fill = {
							bg = "#0E1415",
						},
					},
					options = {
						style_preset = {
							bufferline.style_preset.minimal,
							bufferline.style_preset.no_bold,
						},
						max_name_length = 24,
						tab_size = 24,
						color_icons = false,
						show_buffer_icons = false,
						show_buffer_close_icons = false,
						separator_style = { " ", " " },
					},
				})
			end,
		},
		{
			"SmiteshP/nvim-navic",
			dependencies = {
				"neovim/nvim-lspconfig",
			},
			lazy = true,
			init = function()
				vim.api.nvim_create_autocmd("LspAttach", {
					callback = function(event)
						local client = vim.lsp.get_client_by_id(event.data.client_id)
						if client and client:supports_method("textDocument/documentSymbol") then
							require("nvim-navic").attach(client, event.buf)
						end
					end,
				})
			end,
		},
		{
			"nvim-lualine/lualine.nvim",
			dependencies = {
				"SmiteshP/nvim-navic",
			},
			config = function()
				local project_root = {
					function()
						return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
					end,
					separator = "»",
				}

				local navic = {
					function()
						local navic_ok, navic = pcall(require, "nvim-navic")
						if navic_ok and navic.is_available() then
							return navic.get_location()
						end
						return ""
					end,
					color = { fg = "#888888" },
					separator = "",
				}

				require("lualine").setup({
					options = {
						icons_enabled = true,
						component_separators = "|",
						section_separators = "",
					},
					sections = {
						lualine_c = {
							project_root,
							{ "filename", path = 1 },
							navic,
						},
						lualine_x = { "filetype" },
					},
				})
			end,
		},
		{
			"lewis6991/gitsigns.nvim",
			config = function()
				require("gitsigns").setup({
					signs = {
						add = { text = "+" },
						change = { text = "~" },
						delete = { text = "_" },
						topdelete = { text = "‾" },
						changedelete = { text = "~" },
					},
				})
			end,
		},
		{
			"folke/noice.nvim",
			event = "VeryLazy",
			dependencies = {
				"hrsh7th/nvim-cmp",
			},
			config = function()
				require("noice").setup({})
			end,
		},
		{
			"folke/snacks.nvim",
			dependencies = {
				{ "echasnovski/mini.icons", version = "*" },
			},
			priority = 1000,
			lazy = false,
			opts = {
				dashboard = { enabled = true },
				explorer = {},
				git = { enabled = true },
				gitbrowse = { enabled = true },
				lazygit = { enabled = true },
				indent = {
					enabled = true,
					animate = { enabled = false },
				},
				input = { enabled = true },
				notifier = { enabled = false, timeout = 5000 },
				scope = { enabled = true },
				words = { enabled = true },
			},
		},
		-- ### LSP Related ### --
		{
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup()
			end,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			config = function()
				require("mason-lspconfig").setup({
					ensure_installed = {
						"lua_ls",
						"ts_ls",
						"jsonls",
						"eslint",
						"bashls",
						"yamlls",
						"stylua",
					},
					automatic_enable = false,
				})
			end,
		},
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				"b0o/SchemaStore.nvim",
			},
			config = function()
				vim.lsp.config("ts_ls", {
					settings = {
						diagnostics = {
							ignoredCodes = {
								80001,
								80002,
								80005,
							},
						},
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayVariableTypeHints = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayVariableTypeHints = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				})

				vim.lsp.config("jsonls", {
					settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					},
				})

				vim.lsp.config("eslint", {
					settings = {
						format = true,
					},
				})

				vim.lsp.config("yamlls", {
					settings = {
						yaml = {
							schemaStore = {
								enable = true,
								url = "https://www.schemastore.org/api/json/catalog.json",
							},
						},
					},
				})

				vim.lsp.enable({
					"lua_ls",
					"ts_ls",
					"jsonls",
					"eslint",
					"bashls",
					"yamlls",
				})

				vim.api.nvim_create_autocmd("LspAttach", {
					group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
					callback = function(event)
						local client = vim.lsp.get_client_by_id(event.data.client_id)
						if not client then
							return
						end

						if client.name == "ts_ls" then
							client.server_capabilities.documentFormattingProvider = false
							client.server_capabilities.documentRangeFormattingProvider = false
						end

						if client.name == "eslint" then
							client.server_capabilities.documentFormattingProvider = true
							client.server_capabilities.documentRangeFormattingProvider = true
						end

						vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
					end,
				})
			end,
		},
		{
			"echasnovski/mini.pairs",
			version = false,
			config = function()
				require("mini.pairs").setup()
			end,
		},
		-- ### completion ### --
		{
			"hrsh7th/cmp-nvim-lsp",
		},
		{
			"L3MON4D3/LuaSnip",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp-signature-help",
				"saadparwaiz1/cmp_luasnip",
				"rafamadriz/friendly-snippets",
			},
			version = "v2.*",
			build = "make install_jsregexp",
		},
		{
			"hrsh7th/nvim-cmp",
			config = function()
				local luasnip = require("luasnip")
				local cmp = require("cmp")

				require("luasnip.loaders.from_vscode").lazy_load()

				cmp.setup({
					snippet = {
						expand = function(args)
							require("luasnip").lsp_expand(args.body)
						end,
					},
					window = {
						completion = cmp.config.window.bordered(),
						documentation = cmp.config.window.bordered(),
					},
					mapping = {
						["<Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.locally_jumpable(1) then
								luasnip.jump(1)
							else
								fallback()
							end
						end, { "i", "s" }),
						["<S-Tab>"] = cmp.mapping(function(fallback)
							if cmp.visible() then
								cmp.select_prev_item()
							elseif luasnip.locally_jumpable(-1) then
								luasnip.jump(-1)
							else
								fallback()
							end
						end, { "i", "s" }),
						["<CR>"] = cmp.mapping({
							i = function(fallback)
								if cmp.visible() and cmp.get_active_entry() then
									cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
								else
									fallback()
								end
							end,
							s = cmp.mapping.confirm({ select = true }),
							c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
						}),
					},
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
						{ name = "nvim_lsp_signature_help" },
					}, {
						{ name = "buffer" },
					}),
				})
			end,
		},
	},
	checker = { enabled = true },
	rocks = {
		enabled = false,
	},
})

-- ### AUTO CMD ### --

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
})

-- when opening a buffer, return to the previous location
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- ### KEY BINDINGS ### --

-- keybind dependencies
local telescope_builtin = require("telescope.builtin")
local harpoon = require("harpoon")
local Snacks = require("snacks")

-- using shift is just so much work
vim.keymap.set("n", ";", ":", { nowait = true })
vim.keymap.set("v", ";", ":", { nowait = true })

-- Esc clears search highlight in normal mode
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { desc = "clear search highlights" })

-- toggle line comment
vim.keymap.set("n", "<leader>/", "<Plug>(comment_toggle_linewise_current)", { desc = "Toggle comment, current line" })
vim.keymap.set("v", "<leader>/", "<Plug>(comment_toggle_linewise_visual)", { desc = "Toggle comment, current line" })

-- close a buffer while preserving window layout
vim.keymap.set("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete buffer" })

-- switch open buffers using tab key
vim.keymap.set("n", "<tab>", "<cmd>bnext<CR>", { desc = "next buffer" })
vim.keymap.set("n", "<s-tab>", "<cmd>bprev<CR>", { desc = "previous buffer" })

-- harpoon
vim.keymap.set("n", "<leader>hA", function()
	harpoon:list():prepend()
end, { desc = "Harpoon: prepend" })

vim.keymap.set("n", "<leader>ha", function()
	harpoon:list():add()
end, { desc = "Harpoon: add" })

vim.keymap.set("n", "<leader>hC", function()
	harpoon:list():clear()
	vim.notify("Harpoon list cleared")
end, { desc = "Harpoon: clear list" })

vim.keymap.set("n", "<leader>hc", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: show list" })

vim.keymap.set("n", "<leader>hl", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: show list" })

vim.keymap.set("n", "<leader>h1", function()
	harpoon:list():select(1)
end, { desc = "Harpoon: file position 1" })
vim.keymap.set("n", "<leader>h2", function()
	harpoon:list():select(2)
end, { desc = "Harpoon: file position 2" })
vim.keymap.set("n", "<leader>h3", function()
	harpoon:list():select(3)
end, { desc = "Harpoon: file position 3" })
vim.keymap.set("n", "<leader>h4", function()
	harpoon:list():select(4)
end, { desc = "Harpoon: file position 4" })

-- git
vim.keymap.set("n", "<leader>gg", require("snacks.lazygit").open, { desc = "open lazy git" })
vim.keymap.set("n", "<leader>gb", require("snacks.git").blame_line, { desc = "open git blame" })
vim.keymap.set("n", "<leader>gh", require("snacks.gitbrowse").open, { desc = "open in [g]it [h]ub" })

-- telescope
vim.keymap.set("n", "<leader>sf", telescope_builtin.find_files, { desc = "[s]earch [f]iles" })
vim.keymap.set("n", "<leader>sg", telescope_builtin.live_grep, { desc = "[s]earch by [g]rep" })
vim.keymap.set("n", "<leader>sw", telescope_builtin.grep_string, { desc = "[s]earch for current [w]ord" })
vim.keymap.set("n", "<leader>sr", telescope_builtin.oldfiles, { desc = "[s]earch for [r]ecent files" })
vim.keymap.set("n", "<leader>so", telescope_builtin.buffers, { desc = "[s]earch [o]pen buffers" })
vim.keymap.set("n", "<leader>sh", telescope_builtin.help_tags, { desc = "[s]earch [h]elp" })
vim.keymap.set("n", "<leader>sd", telescope_builtin.diagnostics, { desc = "[s]earch [d]iagnostics" })
vim.keymap.set("n", "<leader>sk", telescope_builtin.keymaps, { desc = "[s]earch [k]eymaps" })
vim.keymap.set("n", "<leader>sl", telescope_builtin.resume, { desc = "[s]earch: resume [l]ast" })
vim.keymap.set("n", "<leader>sm", ":Noice pick<CR>", { desc = "[s]earch editor [m]essages" })

-- neo-tree/snacks explorer
vim.keymap.set("n", "<leader>e", function()
	Snacks.explorer.open({ hidden = true })
end, { desc = "Show file explorer" })

-- lsp
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "[g]o to [d]efinition" })
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "[g]o to [r]eferences" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[c]ode [a]ction" })
vim.keymap.set("n", "<leader>fb", vim.lsp.buf.format, { desc = "[f]ormat [b]uffer" })

-- ### MISC ### --

vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)

-- enables background transparency
vim.cmd([[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]])
