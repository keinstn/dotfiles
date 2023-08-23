-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Color and Appearance
config.color_scheme = "Dracula"
config.window_background_opacity = 0.9

-- Font
config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 14.0

-- and finally, return the configuration to wezterm
return config
