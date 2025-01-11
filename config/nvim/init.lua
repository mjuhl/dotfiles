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
vim.opt.undofile = true -- save undo history


-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ### lazy.nvim ### --

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
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
		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
			config = function()
				vim.cmd.colorscheme("catppuccin-mocha")
			end,
		},
		{
			"folke/which-key.nvim",
		},
		{
			"nullromo/go-up.nvim",
			opts = {},
			config = function(_, opts)
				local goUp = require("go-up")
				goUp.setup(opts)
			end
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
				{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
				{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
				{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
				{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
				{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
			},
		},
		{
			-- when using :46 (e.g.) temporarily jumps to line 46, but back on <Esc>
			"nacro90/numb.nvim",
			event = "BufRead",
			config = function()
				require("numb").setup({
					show_numbers = true, -- Enable 'number' for the window while peeking
					show_cursorline = true, -- Enable 'cursorline' for the window while peeking
				})
			end,
		},
		{
			"rachartier/tiny-inline-diagnostic.nvim",
			-- event = "VeryLazy", -- Or `LspAttach`
			event = "LspAttach", -- Or `LspAttach`
			priority = 1000, -- needs to be loaded in first
			config = function()
				vim.diagnostic.config({ virtual_text = false })
				require("tiny-inline-diagnostic").setup({
					preset = "simple",
					options = {
						-- Show the source of the diagnostic.
						show_source = true,

						-- If multiple diagnostics are under the cursor, display all of them.
						multiple_diag_under_cursor = true,

						-- multilines = {
						-- 	enabled = true,
						-- 	always_show = false,
						-- },

						break_line = {
							enabled = true,
							after = 80,
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
			tag = "0.1.8",
			dependencies = {
				{ "nvim-lua/plenary.nvim" },
				{
					"nvim-telescope/telescope-fzf-native.nvim",
					build = "make",
					cond = function()
						return vim.fn.executable "make" == 1
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
				})

				telescope.load_extension("ui-select")
				telescope.load_extension("fzf")
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			config = function()
				local configs = require("nvim-treesitter.configs")
				configs.setup({
					ensure_installed = {
						"lua",
						"javascript",
						"typescript",
						"html",
						"css",
						"json",
						"yaml",
						"markdown",
						"markdown_inline",
					},
					sync_install = false,
					auto_install = true,
					highlight = { enable = true },
					indent = { enable = true },
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
			"nvim-neo-tree/neo-tree.nvim",
			branch = "v3.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
				-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
			},
			config = function()
				require("neo-tree").setup({
					filesystem = {
						filtered_items = {
							visible = true,
							hide_dotfiles = false,
							hide_gitignored = true,
						},
					},
				})
			end,
		},
		{
			"akinsho/bufferline.nvim",
			version = "*",
			dependencies = "nvim-tree/nvim-web-devicons",
			config = function()
				require("bufferline").setup({
					highlights = require("catppuccin.groups.integrations.bufferline").get(),
					options = {
						show_buffer_close_icons = false,
						offsets = {
							{
								filetype = "neo-tree",
								-- text = "File Tree",
								highlight = "Directory",
								separator = true,
								text_align = "left",
							},
						},
					},
				})
			end,
		},
		{
			"nvim-lualine/lualine.nvim",
			config = function()
				-- display the project root dir name
				local project_root = {
					function()
						return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
					end,
					cond = hide_in_width,
					separator = "»",
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
			---@type snacks.Config
			opts = {
				dashboard = { enabled = true },

				git = { enabled = true },
				gitbrowse = { enabled = true },
				lazygit = { enabled = true },

				indent = {
					enabled = true,
					animate = { enabled = false },
				},

				input = { enabled = true },
				notifier = { enabled = true, timeout = 5000 },
				scope = { enabled = true }, -- use "]" and "[" mappings to jump around based on scope
				words = { enabled = true },
			},
		},
		{
			"utilyre/barbecue.nvim",
			name = "barbecue",
			version = "*",
			dependencies = {
				"SmiteshP/nvim-navic",
				"nvim-tree/nvim-web-devicons", -- optional dependency
			},
			opts = {
				-- configurations go here
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
					-- remember to "setup" each language server in nvim-lspconfig below
					ensure_installed = { "lua_ls", "ts_ls" },
				})
			end,
		},
		{
			"neovim/nvim-lspconfig",
			config = function()
				-- setup lang servers installed with mason/mason-lspconfig
				local lspconfig = require("lspconfig")
				lspconfig.lua_ls.setup({})
				lspconfig.ts_ls.setup({
					settings = {
						diagnostics = {
							-- remove obnoxious and usless suggestions from the typescript language server
							-- see https://github.com/microsoft/TypeScript/blob/v2.9.1/src/compiler/diagnosticMessages.json
							ignoredCodes = {
								80001, -- "File is a CommonJS module; it may be converted to an ES6 module."
								80002, -- "This constructor function may be converted to a class declaration."
								80005, -- "'require' call may be converted to an import."
							},
						},
					},
				})
			end,
		},
		{
			"nvimtools/none-ls.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvimtools/none-ls-extras.nvim",
			},
			config = function()
				local null_ls = require("null-ls")
				null_ls.setup({
					sources = {
						-- linters/formatters:
						null_ls.builtins.formatting.stylua,
						require("none-ls.diagnostics.eslint"),
						require("none-ls.formatting.eslint"),
						require("none-ls.code_actions.eslint"),
					},
				})
			end,
		},
		{
			"jay-babu/mason-null-ls.nvim",
			config = function()
				require("mason-null-ls").setup({
					ensure_installed = nil,
					automatic_installation = true,
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

			-- see: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#transformations
			-- build = see: "make install_jsregexp",
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
					}, -- /mapping
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
						{ name = "nvim_lsp_signature_help" },
					}, {
						{ name = "buffer" },
					}), -- /sources
				})
			end,
		},
		-- end of completion stuff
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "catppuccin" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

-- ### AUTO CMD ### --

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
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

-- Navigate vim panes better
-- vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
-- vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
-- vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
-- vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")

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
vim.keymap.set("n", "<tab>", "<cmd>BufferLineCycleNext<CR>", { desc = "next tab" })
vim.keymap.set("n", "<s-tab>", "<cmd>BufferLineCyclePrev<CR>", { desc = "previous tab" })

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

vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon: file position 1"})
vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon: file position 2"})
vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon: file position 3"})
vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon: file position 4"})
-- vim.keymap.set("n", "<leader><C-h>", function() harpoon:list():replace_at(1) end)
-- vim.keymap.set("n", "<leader><C-t>", function() harpoon:list():replace_at(2) end)
-- vim.keymap.set("n", "<leader><C-n>", function() harpoon:list():replace_at(3) end)
-- vim.keymap.set("n", "<leader><C-s>", function() harpoon:list():replace_at(4) end)

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

-- neo-tree
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { desc = "Show neo-tree filesystem" })

-- lsp
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "[g]o to [d]efinition" })
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "[g]o to [r]eferences" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "[c]ode [a]ction" })
vim.keymap.set("n", "<leader>fb", vim.lsp.buf.format, { desc = "[f]ormat [b]uffer" })
vim.keymap.set("v", "<leader>fs", function()
	vim.lsp.buf.format({
		range = { ["start"] = vim.api.nvim_buf_get_mark(0, "<"), ["end"] = vim.api.nvim_buf_get_mark(0, ">") },
	})
end, { desc = "[f]ormat [s]election" })


-- terminal
-- FIXME: this is not working in tmux
vim.keymap.set("n", "<c-/>", function()
	Snacks.terminal()
end, { desc = "Toggle terminal" })
-- vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("t", "<c-/>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

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
