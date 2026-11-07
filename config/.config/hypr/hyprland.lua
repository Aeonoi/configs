-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")

local ipc = "noctalia msg "
local mainMod = "ALT"
local superMod = "SUPER"

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "eDP-1",
	mode = "3840x2400@60.00Hz",
	position = "0x0",
	scale = "2",
})
hl.monitor({
	output = "HDMI-A-2",
	mode = "1920x1080@165.00Hz",
	position = "auto",
	scale = "1",
})

for i = 1, 6 do
	hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-2" })
end

for i = 7, 10 do
	hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1" })
end

---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal = "alacritty"
local fileManager = "ranger"
local browser = "firefox"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("noctalia &")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- hl.env("AQ_FORCE_LINEAR_BLIT", "0")
-- hl.env("NVD_BACKEND", "direct")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 0,
		gaps_out = 0,

		border_size = 2,

		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		-- Set to true to enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = true,

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = false,

		layout = "scrolling",
	},

	decoration = {
		rounding = 0,
		rounding_power = 2,

		-- Change transparency of focused and unfocused windows
		active_opacity = 1.0,
		inactive_opacity = 1.0,

		shadow = {
			enabled = false,
			range = 4,
			render_power = 3,
			color = 0xee1a1a1a,
		},

		blur = {
			enabled = false,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		},
	},

	animations = {
		enabled = true,
	},
})
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 1, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, bezier = "default", style = "popin 60%" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "default" })

hl.config({
	-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
	dwindle = {
		preserve_split = true, -- You probably want this
	},
	-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
	master = {
		new_status = "master",
	},
	-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
	scrolling = {
		fullscreen_on_one_column = true,
	},
})

----------------
----  MISC  ----
----------------

hl.config({
	misc = {
		force_default_wallpaper = -0, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
	},
})

hl.config({
	group = {
		insert_after_current = true,
		groupbar = {
			gradients = true,
			font_family = "JetBrainsMono Nerd Font",
			font_size = 16,
			font_weight_active = "bold",
			font_weight_inactive = "normal",
			text_color = "0xffffffff",
			text_color_inactive = "0xffaaaaaa",
			blur = false,
		},
	},
})

-----------------
----  BINDS  ----
-----------------

hl.config({
	binds = {
		workspace_back_and_forth = false,
	},
})

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,

		sensitivity = -0.8, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = true,
			disable_while_typing = false,
		},
	},
})

hl.device({
	name = "logitech-g203-lightsync-gaming-mouse",
	sensitivity = -0.8,
})
hl.device({
	name = "elan067a:00-04f3:3197-touchpad",
	sensitivity = 0,
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.gesture({
	fingers = 4,
	direction = "horizontal",
	action = "workspace",
})

---------------------
---- KEYBINDINGS ----
---------------------

hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))

hl.bind(superMod .. " + L", hl.dsp.exec_cmd(ipc .. "session lock-and-suspend"))

-- Screenshot a monitor
hl.bind("PRINT", hl.dsp.exec_cmd(ipc .. "screenshot-fullscreen pick"))
-- Screenshot a region
hl.bind(mainMod .. " +  SHIFT + S", hl.dsp.exec_cmd(ipc .. "screenshot-region"))

---------------------
---  GROUPING     ---
---------------------

-- Toggle current window to be a group or stack in other window manager lingo
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())

hl.bind(mainMod .. " + TAB", hl.dsp.group.next())
hl.bind(mainMod .. "+ SHIFT + TAB", hl.dsp.group.prev())

-- Move current window into an existing tab group or create a new one
hl.bind(mainMod .. " + CTRL + LEFT", hl.dsp.window.move({ into_or_create_group = "left" }))
hl.bind(mainMod .. " + CTRL + RIGHT", hl.dsp.window.move({ into_or_create_group = "right" }))
hl.bind(mainMod .. " + CTRL + UP", hl.dsp.window.move({ into_or_create_group = "up" }))
hl.bind(mainMod .. " + CTRL + DOWN", hl.dsp.window.move({ into_or_create_group = "down" }))

-- Reorder the current window's position within its own group
hl.bind(mainMod .. " + SHIFT + LEFT", hl.dsp.window.move({ out_of_group = "left" }))
hl.bind(mainMod .. " + SHIFT + RIGHT", hl.dsp.window.move({ out_of_group = "right" }))
hl.bind(mainMod .. " + SHIFT + UP", hl.dsp.window.move({ out_of_group = "up" }))
hl.bind(mainMod .. " + SHIFT + DOWN", hl.dsp.window.move({ out_of_group = "down" }))

---------------------

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(
	mainMod .. " + O",
	hl.dsp.exec_cmd(
		"spotify --enable-blink-features=MiddleClickAutoscroll --enable-features=UseOzonePlatform --ozone-platform=wayland"
	)
)

hl.bind(mainMod .. " + SHIFT + W", hl.dsp.window.kill())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))

-- Resize windows
local resizeUnit = 20
hl.bind(
	mainMod .. " + CTRL + l",
	hl.dsp.window.resize({ x = resizeUnit, y = 0, relative = true }),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + CTRL + h",
	hl.dsp.window.resize({ x = -resizeUnit, y = 0, relative = true }),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + CTRL + k",
	hl.dsp.window.resize({ x = 0, y = -resizeUnit, relative = true }),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + CTRL + j",
	hl.dsp.window.resize({ x = 0, y = resizeUnit, relative = true }),
	{ repeating = true }
)

-- Workspace stuff
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	-- Switch workspaces with mainMod + [0-9]
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))

	-- Move window to a different workspace and switch to that workspace with mainMod + SHIFT + [0-9]
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
	-- Move window to a different workspace but keep current workspace with mainMod + CTRL + [0-9]
	hl.bind(mainMod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(superMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(superMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), -- remove -l 1 to remove 100% limit
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.window_rule({
	name = "move-spotify",
	match = {
		class = "Spotify",
	},
	workspace = "10",
})

hl.window_rule({
	name = "move-discord",
	match = {
		class = "^[dD]iscord$",
	},
	workspace = "9",
})

-- Hyprland-run windowrule
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },

	move = "20 monitor_h-120",
	float = true,
})
-- Suppress maximize requests from all apps
hl.window_rule({
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Hide empty XWayland helper windows (Wine tray/menu helpers, etc.)
hl.window_rule({
	match = {
		xwayland = true,
		title = "^$",
		class = "^$",
		initial_class = "^$",
		initial_title = "^$",
	},
	opacity = "0.0 override 0.0 override",
	no_blur = true,
	no_initial_focus = true,
})
-- Suppress maximize requests from all apps
hl.window_rule({
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Hide empty XWayland helper windows (Wine tray/menu helpers, etc.)
hl.window_rule({
	match = {
		xwayland = true,
		title = "^$",
		class = "^$",
		initial_class = "^$",
		initial_title = "^$",
	},
	opacity = "0.0 override 0.0 override",
	no_blur = true,
	no_initial_focus = true,
})
