local wezterm = require("wezterm")
local act = wezterm.action

config = wezterm.config_builder()

config = {
	automatically_reload_config = true,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	color_scheme = "Catppuccin Mocha",
	font = wezterm.font("MesloLGL Nerd Font"),
	font_size = 14.0,
	-- Side effect: also thickens underlines (URLs, underlined text).
	underline_thickness = "400%",
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = false,
	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = true,
	use_dead_keys = false,
	initial_rows = 45,
	initial_cols = 180,
	window_background_opacity = 0.95,
	macos_window_background_blur = 20,
	tab_max_width = 36,
}

local base_colors = {
	split = "#CBA6F7",
	tab_bar = {
		background = "#181825",
		new_tab = { bg_color = "#181825", fg_color = "#6c7086" },
		new_tab_hover = { bg_color = "#313244", fg_color = "#cdd6f4" },
	},
}
config.colors = base_colors

config.inactive_pane_hsb = {
	brightness = 0.7,
	saturation = 1.0,
}

config.mouse_bindings = {
	-- Click selects text only, without opening hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelection("PrimarySelection"),
	},

	-- CMD+Click opens the hyperlink under the cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CMD",
		action = act.OpenLinkAtMouseCursor,
	},

	-- Block the Down event of CMD+Click to avoid side effects
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
	-- Pane splitting
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
	-- Pane resizing
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
	-- Tab switching
	{
		mods = "CTRL",
		key = "LeftArrow",
		action = act.ActivateTabRelative(-1),
	},
	{
		mods = "CTRL",
		key = "RightArrow",
		action = act.ActivateTabRelative(1),
	},
}

-- Catppuccin Mocha
local green = "#a6e3a1"
local red = "#f38ba8"
local green_active = "#2ea043"
local red_active = "#e5534b"
local white = "#cdd6f4"
local mauve = "#cba6f7"
local mauve_dim = "#6c5f8c" -- faded mauve: active-tab bg when the window is unfocused
local grey_text = "#a6adc8" -- greyer tab text when the window is unfocused
local inactive_fg = "#7f849c" -- greyed-out text for inactive (non-current) tabs
local base = "#1e1e2e"

-- Whether WezTerm currently has OS focus; updated by window-focus-changed and
-- read by format-tab-title to dim the active tab when unfocused (VS Code-like).
local window_focused = true
local bar_bg = "#181825"
local inactive_bg = "#313244"

local function truncate(s, max)
	if #s > max then
		return s:sub(1, max - 1) .. "…"
	end
	return s
end

-- Tab title: "✔ 📂 folder" at prompt (green/red), "📂 folder $ cmd" when running
wezterm.on("format-tab-title", function(tab)
	local pane = tab.active_pane
	if not pane then
		return tab.tab_title
	end

	-- Current folder (last path component)
	local folder = "~"
	local cwd = pane.current_working_dir
	if cwd then
		local path = cwd.file_path
		folder = path:match("([^/]+)/?$") or path
		if folder == "" then
			folder = "/"
		end
	end

	local cmd = pane.user_vars.wt_cmd or ""
	local exit_code = tonumber(pane.user_vars.wt_exit) or 0
	local icon = exit_code == 0 and "\u{2714}" or "\u{2718}"
	local icon_color = exit_code == 0 and (tab.is_active and green_active or green)
		or (tab.is_active and red_active or red)

	-- When focused, keep the normal look (vivid mauve active tab, white inactive
	-- tabs); when unfocused, grey everything down a bit.
	local active_bg = window_focused and mauve or mauve_dim
	local active_fg = window_focused and base or grey_text
	local inactive_tab_fg = window_focused and white or inactive_fg
	local this_bg = tab.is_active and active_bg or inactive_bg
	local this_fg = tab.is_active and active_fg or inactive_tab_fg

	local segments = { { Background = { Color = this_bg } } }

	if cmd == "" then
		table.insert(segments, { Foreground = { Color = icon_color } })
		table.insert(segments, { Text = " " .. icon .. " " })
	end

	table.insert(segments, { Attribute = { Italic = true } })
	table.insert(segments, { Foreground = { Color = this_fg } })
	table.insert(segments, { Text = " 📂 " .. truncate(folder, 18) })
	table.insert(segments, { Attribute = { Italic = false } })

	if cmd ~= "" then
		table.insert(segments, { Attribute = { Intensity = "Bold" } })
		table.insert(segments, { Foreground = { Color = this_fg } })
		table.insert(segments, { Text = " $ " .. truncate(cmd, 28 - #folder) })
		table.insert(segments, { Attribute = { Intensity = "Normal" } })
	end

	table.insert(segments, { Text = " " })

	-- Dark gap between tabs
	table.insert(segments, { Background = { Color = bar_bg } })
	table.insert(segments, { Text = " " })

	return segments
end)

-- VS Code-like focus effect: when WezTerm has OS focus, darken the window
-- background a touch and darken the tab bar so the active (mauve) tab pops;
-- when another app is focused, gently dim/desaturate the colors.
wezterm.on("window-focus-changed", function(window, pane)
	window_focused = window:is_focused()
	local overrides = window:get_config_overrides() or {}
	if window_focused then
		overrides.foreground_text_hsb = nil
		overrides.colors = {
			split = base_colors.split,
			background = "#181825", -- a bit darker than the scheme base (#1e1e2e)
			tab_bar = {
				background = "#313244", -- lighter grey for the empty bar area (right side)
				new_tab = base_colors.tab_bar.new_tab,
				new_tab_hover = base_colors.tab_bar.new_tab_hover,
			},
		}
	else
		-- Gently dim/desaturate; keep the normal (lighter) window bg and a lighter grey bar
		overrides.foreground_text_hsb = { saturation = 0.7, brightness = 0.85 }
		overrides.colors = {
			split = base_colors.split,
			tab_bar = {
				background = "#313244", -- lighter grey for the empty bar area (right side)
				new_tab = base_colors.tab_bar.new_tab,
				new_tab_hover = base_colors.tab_bar.new_tab_hover,
			},
		}
	end
	window:set_config_overrides(overrides)
end)

return config
