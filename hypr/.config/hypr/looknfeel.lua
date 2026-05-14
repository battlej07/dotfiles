require("colourpalette")

hl.config({
	general = {
		border_size = 2,
		gaps_in = 5,
		gaps_out = 10,
		gaps_workspaces = 5,
		col = {
			active_border = Green,
			inactive_border = Grey0,
		},
		no_focus_fallback = true,
		resize_on_border = true,
		allow_tearing = true,
	},
	decoration = {
		rounding = 8,
		rounding_power = 4,
		shadow = {
			color = Grey1,
			color_inactive = Grey2,
		},
	},
	dwindle = {
		preserve_split = true,
	},
	misc = {
		disable_hyprland_logo = true,
		font_family = "JetBrainsMono Nerd Font",
		splash_font_family = "JetBrainsMono Nerd Font",
	},
})

-- Animations
hl.config({ animations = { workspace_wraparound = false } })

hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "default", style = "slide" })
hl.animation({ leaf = "layers", enabled = true, speed = 4, bezier = "default", style = "slide" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "default", style = "slide" })
