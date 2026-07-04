local wezterm = require("wezterm")
local act = wezterm.action

local config = wezterm.config_builder()

config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.window_decorations = "RESIZE"
config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" })
config.font_size = 14.0
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true
config.use_dead_keys = false
config.initial_rows = 45
config.initial_cols = 180
config.window_background_opacity = 1
-- Only takes effect when window_background_opacity drops below 1
config.macos_window_background_blur = 20
config.tab_max_width = 36

-- Thicker underlines for underlined text and hyperlinks
config.underline_thickness = "200%"

-- Font rendering
config.freetype_load_target = "Light"
config.freetype_render_target = "Light"
-- Breathable line spacing, like a modern editor
config.line_height = 1.2

-- Inner padding for an airy app-like look (text no longer hugs the edges)
config.window_padding = { left = 14, right = 14, top = 10, bottom = 8 }

-- Thin blinking bar cursor with a soft ease (editor-style).
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 600
config.cursor_blink_ease_in = "EaseOut"
config.cursor_blink_ease_out = "EaseOut"
config.animation_fps = 60

local base_colors = {
	-- Brighter default text than Catppuccin Mocha's #cdd6f4 for stronger
	-- contrast against the dark background (keeps the cool, slightly-blue tint)
	foreground = "#e6e9f0",
	split = "#CBA6F7",
	tab_bar = {
		background = "#313244", -- lighter grey for the empty bar area (right of the tabs)
		new_tab = { bg_color = "#181825", fg_color = "#6c7086" },
		new_tab_hover = { bg_color = "#313244", fg_color = "#cdd6f4" },
	},
}
config.colors = base_colors

-- Recede inactive panes to sharpen the active/inactive contrast: dim them and
-- desaturate them. Applies to inactive panes only, so the active pane is left
-- untouched. Tune saturation/brightness to taste; 1.0 = no change.
config.inactive_pane_hsb = {
	brightness = 0.55,
	saturation = 0.85,
}

-- 1 arrow-key press per wheel tick (default 3) for fullscreen/alt-screen apps
-- (e.g. Claude Code, vim, htop) that don't handle mouse reporting themselves
config.alternate_buffer_wheel_scroll_speed = 1

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

-- Routage intelligent tmux : si le pane au premier plan exécute tmux, la
-- touche est traduite en séquence tmux (préfixe Ctrl+a + binding standard) ;
-- sinon WezTerm garde son action native. Limite connue : sous ssh, le
-- processus vu est `ssh`, donc un tmux distant reçoit l'action native.
local function tmux_or(seq, native_action)
	return wezterm.action_callback(function(window, pane)
		local proc = pane:get_foreground_process_name() or ""
		local name = proc:match("([^/]+)$") or ""
		if name == "tmux" then
			window:perform_action(act.SendString(seq), pane)
		else
			window:perform_action(native_action, pane)
		end
	end)
end

local tmux_prefix = "\x00" -- Ctrl+Space

-- Keybindings
config.keys = {
	{
		key = "-",
		mods = "CTRL",
		action = act.DisableDefaultAssignment,
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
	-- Pane splitting (dans tmux : | et - ouvrent dans le répertoire courant)
	{
		mods = "CTRL|SHIFT",
		key = "i",
		action = tmux_or(tmux_prefix .. "|", act.SplitHorizontal({ domain = "CurrentPaneDomain" })),
	},
	{
		mods = "CTRL|SHIFT",
		key = "o",
		action = tmux_or(tmux_prefix .. "-", act.SplitVertical({ domain = "CurrentPaneDomain" })),
	},
	-- Pane resizing (dans tmux : préfixe + Ctrl+flèche = resize-pane)
	{
		mods = "CTRL|SHIFT",
		key = "UpArrow",
		action = tmux_or(tmux_prefix .. "\x1b[1;5A", act.AdjustPaneSize({ "Up", 1 })),
	},
	{
		mods = "CTRL|SHIFT",
		key = "DownArrow",
		action = tmux_or(tmux_prefix .. "\x1b[1;5B", act.AdjustPaneSize({ "Down", 1 })),
	},
	{
		mods = "CTRL|SHIFT",
		key = "LeftArrow",
		action = tmux_or(tmux_prefix .. "\x1b[1;5D", act.AdjustPaneSize({ "Left", 1 })),
	},
	{
		mods = "CTRL|SHIFT",
		key = "RightArrow",
		action = tmux_or(tmux_prefix .. "\x1b[1;5C", act.AdjustPaneSize({ "Right", 1 })),
	},
	-- Close pane (dans tmux : X = kill-pane sans confirmation, binding custom)
	{
		mods = "SUPER",
		key = "w",
		action = tmux_or(tmux_prefix .. "X", act.CloseCurrentPane({ confirm = false })),
	},
	{
		mods = "SUPER|SHIFT",
		key = "Enter",
		action = tmux_or(tmux_prefix .. "z", act.TogglePaneZoomState),
	},
	{
		mods = "SUPER",
		key = "LeftArrow",
		action = tmux_or(tmux_prefix .. "\x1b[D", act.ActivatePaneDirection("Left")),
	},
	{
		mods = "SUPER",
		key = "RightArrow",
		action = tmux_or(tmux_prefix .. "\x1b[C", act.ActivatePaneDirection("Right")),
	},
	{
		mods = "SUPER",
		key = "UpArrow",
		action = tmux_or(tmux_prefix .. "\x1b[A", act.ActivatePaneDirection("Up")),
	},
	{
		mods = "SUPER",
		key = "DownArrow",
		action = tmux_or(tmux_prefix .. "\x1b[B", act.ActivatePaneDirection("Down")),
	},
	-- New tab (dans tmux : nouvelle window)
	{
		mods = "SUPER",
		key = "t",
		action = tmux_or(tmux_prefix .. "c", act.SpawnTab("CurrentPaneDomain")),
	},
	-- Tab switching (dans tmux : fenêtre précédente/suivante)
	{
		mods = "CTRL",
		key = "LeftArrow",
		action = tmux_or(tmux_prefix .. "p", act.ActivateTabRelative(-1)),
	},
	{
		mods = "CTRL",
		key = "RightArrow",
		action = tmux_or(tmux_prefix .. "n", act.ActivateTabRelative(1)),
	},
	{
		mods = "CTRL",
		key = "Tab",
		action = tmux_or(tmux_prefix .. "n", act.ActivateTabRelative(1)),
	},
	{
		mods = "CTRL|SHIFT",
		key = "Tab",
		action = tmux_or(tmux_prefix .. "p", act.ActivateTabRelative(-1)),
	},
}

-- Palette: Catppuccin Mocha tones + a few custom accents (active green/red)
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
-- read by format-tab-title to dim the active tab when unfocused (VS Code-like)
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
	local folder_disp = truncate(folder, 18)

	local cmd = pane.user_vars.wt_cmd or ""
	local exit_code = tonumber(pane.user_vars.wt_exit) or 0
	local icon = exit_code == 0 and "\u{2714}" or "\u{2718}"
	local icon_color = exit_code == 0 and (tab.is_active and green_active or green)
		or (tab.is_active and red_active or red)

	-- When focused, keep the normal look (vivid mauve active tab, white inactive
	-- tabs); when unfocused, grey everything down a bit
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
	table.insert(segments, { Attribute = { Intensity = "Bold" } })
	table.insert(segments, { Foreground = { Color = this_fg } })
	table.insert(segments, { Text = " 📂 " .. folder_disp })
	table.insert(segments, { Attribute = { Intensity = "Normal" } })
	table.insert(segments, { Attribute = { Italic = false } })

	if cmd ~= "" then
		table.insert(segments, { Attribute = { Intensity = "Bold" } })
		table.insert(segments, { Foreground = { Color = this_fg } })
		-- Budget the command by what's left in tab_max_width after " 📂 ", " $ ",
		-- the trailing space and the dark inter-tab gap (≈10 cols) so that gap is
		-- never clipped; clamp to >= 1 so a long folder name can't pass a negative max
		table.insert(segments, { Text = " $ " .. truncate(cmd, math.max(1, config.tab_max_width - 10 - #folder_disp)) })
		table.insert(segments, { Attribute = { Intensity = "Normal" } })
	end

	table.insert(segments, { Text = " " })

	-- Dark gap between tabs
	table.insert(segments, { Background = { Color = bar_bg } })
	table.insert(segments, { Text = " " })

	return segments
end)

-- Track OS focus
wezterm.on("window-focus-changed", function(window, pane)
	window_focused = window:is_focused()
	local overrides = window:get_config_overrides() or {}
	overrides.foreground_text_hsb = {
		brightness = window_focused and 1.0 or 0.7,
		saturation = window_focused and 1.0 or 0.85,
	}
	window:set_config_overrides(overrides)
end)

return config
