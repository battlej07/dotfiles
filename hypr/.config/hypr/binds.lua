local terminal = "kitty"
local browser = "firefox"

hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(terminal), { description = "Open default terminal" })
hl.bind("SUPER + B", hl.dsp.exec_cmd(browser), { description = "Open default browser" })
hl.bind("SUPER + W", hl.dsp.window.kill(), { description = "Kill active window" })

local directions = { H = "left", L = "right", K = "up", J = "down" }

for key, direction in pairs(directions) do
	hl.bind("SUPER + " .. key, hl.dsp.focus({ direction = direction }), { description = "Move focus " .. direction })
	hl.bind(
		"SUPER + SHIFT + " .. key,
		hl.dsp.window.move({ direction = direction }),
		{ description = "Move window " .. direction }
	)
end

for i = 1, 9 do
	hl.bind("SUPER + " .. i, hl.dsp.focus({ workspace = i }), { description = "Switch to workspace " .. i })
	hl.bind(
		"SUPER + SHIFT + " .. i,
		hl.dsp.window.move({ workspace = i }),
		{ description = "Move window to workspace " .. i }
	)
end

hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e+1" }), { description = "Cycle through workspaces" })
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e-1" }), { description = "Cycle through workspaces" })
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { description = "Move window with mouse" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { description = "Resize window with mouse" })

hl.bind("F11", hl.dsp.window.fullscreen(), { description = "Toggle fullscreen" })

hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("screenshot"), { description = "Take a screenshot" })
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd("kitty --class powermenu -e powermenu"), { description = "Open powermenu" })

hl.bind("SUPER + F", hl.dsp.window.float({ "toggle" }), { description = "Toggle floating" })

hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("launcher"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("floating-tui yazi"))

-- Volume
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ repeating = true, locked = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ repeating = true, locked = true }
)

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { repeating = true, locked = true })

-- Media (requires playerctl)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
