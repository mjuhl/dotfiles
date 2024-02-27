-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

vim.opt.expandtab = false
vim.opt.wrap = true
vim.opt.relativenumber = false

lvim.colorscheme = "moonlight"
-- lvim.colorscheme = "nord"
-- lvim.colorscheme = "poimandres"
-- lvim.colorscheme = "tokyonight-night"
-- lvim.colorscheme = "lunar"
-- lvim.colorscheme = "blue-moon"

-------------------------------------------------------------------------------
-- keymappings
-------------------------------------------------------------------------------
lvim.keys.normal_mode["<tab>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-tab>"] = ":BufferLineCyclePrev<CR>"
-- space,g,h opens file in github to current line
lvim.keys.normal_mode["<Leader>gh"] = ":OpenInGHFileLines<CR>" 
-- using shift is just so much work
vim.keymap.set("n", ";", ":", { nowait = true })
vim.keymap.set("v", ";", ":", { nowait = true })
-- see https://vim.fandom.com/wiki/Map_semicolon_to_colon 
-- vim.keymap.set("n", ";;", ";", { noremap = true })

-------------------------------------------------------------------------------
-- linters
-------------------------------------------------------------------------------
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup({
	-- { name = "eslint_d" },
-- })

-------------------------------------------------------------------------------
-- core plugin setups
-------------------------------------------------------------------------------

-- TODO: configure telescope live grep to be case insensitive

local lsp_manager = require("lvim.lsp.manager")
-- hide annoying diagnostics, see: https://stackoverflow.com/a/70294761
lsp_manager.setup("tsserver", {
  on_attach = function(client, bufnr)
      require('nvim-lsp-ts-utils').setup({
          filter_out_diagnostics_by_code = { 80001 },
      })
      require('nvim-lsp-ts-utils').setup_client(client)
  end,
})

-------------------------------------------------------------------------------
-- custom plugins
-------------------------------------------------------------------------------
lvim.plugins = {
	-- color schemes, see: https://github.com/rockerBOO/awesome-neovim#colorscheme
	{ "folke/tokyonight.nvim" },
	{ "arcticicestudio/nord-vim" },
	{ "shaunsingh/moonlight.nvim" },
	{ "olivercederborg/poimandres.nvim" },
	{
		"kyazdani42/blue-moon",
		config = function()
			vim.opt.termguicolors = true
			vim.cmd "colorscheme blue-moon"
		end
	},

	-- other plugins
	{ "dense-analysis/ale" },
  {
    "nmac427/guess-indent.nvim", -- auto detect file indentation and set tabs correctly 
    config = function() require('guess-indent').setup {} end,
    lazy = false,
  },
	{
		"almo7aya/openingh.nvim",
	},
	{
		-- used with tsserver to disable annoying diagnostics
		"jose-elias-alvarez/nvim-lsp-ts-utils"
	},
	{
		-- when using :46 (e.g.) temporarily jumps to line 46, but back on <Esc>
		"nacro90/numb.nvim",
		event = "BufRead",
		config = function()
			require("numb").setup {
				show_numbers = true, -- Enable 'number' for the window while peeking
				show_cursorline = true, -- Enable 'cursorline' for the window while peeking
			}
		end,
	},

	{
		-- highlighting for task comments, e.g.:
		-- 	//  FIXME: bla bla bla 
		--  //  TODO:  bla bla bla
		"folke/todo-comments.nvim",
		event = "BufRead",
		config = function()
			require("todo-comments").setup({
			})
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "BufRead",
		config = function() require"lsp_signature".on_attach() end,
	},

	-- neorg
	{
    "nvim-neorg/neorg",
    build = ":Neorg sync-parsers",
    dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"nvim-cmp",
			"nvim-lua/plenary.nvim",
		},
    config = function()
      require("neorg").setup {
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
					["core.completion"] = { config = { engine = "nvim-cmp", name = "[Norg]" } },
					["core.integrations.nvim-cmp"] = {},
					["core.concealer"] = { config = { icon_preset = "diamond" } },
					["core.export"] = {},
          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                home = "~/notes/home",
                sv = "~/notes/sv",
              },
							default_workspace = "sv",
            },
          },
					["core.keybinds"] = {
						-- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
						config = {
							default_keybinds = true,
							-- neorg_leader = "<Leader><Leader>",
						},
					},
        },
      }
    end,
  },
}

