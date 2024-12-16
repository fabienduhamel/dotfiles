local wezterm = require("wezterm")
local act = wezterm.action

config = wezterm.config_builder()

config = {
	automatically_reload_config = true,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	color_scheme = "Catppuccin Macchiato",
	font = wezterm.font("MesloLGL Nerd Font"),
	font_size = 14.0,
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = false,
	use_dead_keys = false,
	initial_rows = 45,
	initial_cols = 180,
	window_background_opacity = 0.95,
	macos_window_background_blur = 20,
}

-- Keybindings
config.keys = {
	{
		mods = "OPT",
		key = "n",
		action = act.SendKey({ key = "~" }),
	},
	{
		mods = "OPT",
		key = "LeftArrow",
		action = act.SendKey({ key = "b", mods = "ALT" }),
	},
	{
		mods = "OPT",
		key = "RightArrow",
		action = act.SendKey({ key = "f", mods = "ALT" }),
	},
	-- splitting
	{
		mods = "CTRL|SHIFT",
		key = "i",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "CTRL|SHIFT",
		key = "o",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "SUPER",
		key = "w",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		mods = "SUPER|SHIFT",
		key = "Enter",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		mods = "SUPER",
		key = "LeftArrow",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		mods = "SUPER",
		key = "RightArrow",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		mods = "SUPER",
		key = "UpArrow",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		mods = "SUPER",
		key = "DownArrow",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
	{
		mods = "SUPER|CTRL|ALT|SHIFT",
		key = "[",
		action = wezterm.action.SwitchWorkspaceRelative(-1),
	},
	{
		mods = "SUPER|CTRL|ALT|SHIFT",
		key = "]",
		action = wezterm.action.SwitchWorkspaceRelative(1),
	},
	{
		key = "9",
		mods = "SUPER|CTRL|ALT|SHIFT",
		action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
	{
		key = "k",
		mods = "SUPER",
		action = wezterm.action.ClearScrollback("ScrollbackAndViewport"),
	},
}

return config