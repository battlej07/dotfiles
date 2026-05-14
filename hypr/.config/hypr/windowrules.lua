-- Launcher
hl.window_rule({
	name = "launcher",
	match = { class = "sway-launcher-desktop" },
	float = true,
	size = { 500, 500 },
	center = true,
	stay_focused = true,
	dim_around = true,
})

-- Floating TUIs
hl.window_rule({
	name = "floating-tuis",
	match = { class = "^(floating-tui|com\\.gabm\\.satty)$" },
	float = true,
	size = { 1200, 700 },
	center = true,
})

-- Power menu
hl.window_rule({
	name = "powermenu",
	match = { class = "powermenu" },
	float = true,
	size = { 200, 150 },
	center = true,
})

-- Suppress maximize events from all apps
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Fix XWayland drag issues
hl.window_rule({
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

-- xwaylandvideobridge fixes
hl.window_rule({
	name = "xwayland-video-bridge-fixes",
	match = { class = "xwaylandvideobridge" },
	no_initial_focus = true,
	no_focus = true,
	no_anim = true,
	no_blur = true,
	max_size = { 1, 1 },
	opacity = "0.0 override 0.0 override",
})
