-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- config.color_scheme = 'AdventureTime'
-- config.color_scheme = 'Kanagawa (Gogh)'
config.color_scheme_dirs = { 'C:\\Users\\matthew.juhl\\dev\\dotfiles\\.config\\wezterm\\colors\\' }
config.color_scheme = 'darcubox'
config.font = wezterm.font 'SauceCodePro Nerd Font'
config.font_size = 10.0

config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.98

-- custom key mappings
config.keys = {
	{
		key = "v",
		mods = "CTRL",
		action = wezterm.action.PasteFrom("Clipboard"),
	},
	{
		key = "c",
		mods = "CTRL",
		-- action = wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
				if has_selection then
					window:perform_action(
						wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
						pane
					)
				else
					window:perform_action(
						wezterm.action.SendKey({ key = "c", mods = "CTRL" }),
						pane
					)
				end
			end),
	},
}

-- and finally, return the configuration to wezterm
return config

-- to reload config, press ctl+shift+r

