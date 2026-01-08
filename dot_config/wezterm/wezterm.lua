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
	send_composed_key_when_right_alt_is_pressed = true,
	use_dead_keys = false,
	initial_rows = 45,
	initial_cols = 180,
	window_background_opacity = 0.95,
	macos_window_background_blur = 20,
}

config.colors = {
	split = "#DADADA",
}

config.inactive_pane_hsb = {
	brightness = 0.7,
	saturation = 1.0,
}

config.mouse_bindings = {
	-- Change the default click behavior so that it only selects
	-- text and doesn't open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelection("PrimarySelection"),
	},

	-- and make CTRL-Click open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CMD",
		action = act.OpenLinkAtMouseCursor,
	},

	-- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
	{
		event = { Down = { streak = 1, button = "Left" } },
		mods = "CMD",
		action = act.Nop,
	},
}

-- Keybindings
config.keys = {
	{
		key = "-",
		mods = "CTRL",
		action = wezterm.action.DisableDefaultAssignment,
	},
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
	-- pane resizing
	{
		mods = "CTRL|SHIFT",
		key = "UpArrow",
		action = wezterm.action.AdjustPaneSize({ "Up", 1 }),
	},
	{
		mods = "CTRL|SHIFT",
		key = "DownArrow",
		action = wezterm.action.AdjustPaneSize({ "Down", 1 }),
	},
	{
		mods = "CTRL|SHIFT",
		key = "LeftArrow",
		action = wezterm.action.AdjustPaneSize({ "Left", 1 }),
	},
	{
		mods = "CTRL|SHIFT",
		key = "RightArrow",
		action = wezterm.action.AdjustPaneSize({ "Right", 1 }),
	},
	{
		mods = "SUPER",
		key = "w",
		action = wezterm.action.CloseCurrentPane({ confirm = false }),
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
}

return config
