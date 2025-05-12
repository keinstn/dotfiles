-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

local function get_os()
  return package.config:sub(1, 1) == "/" and "Linux" or "Windows"
end

local is_unix = get_os() == "Linux"

-- This table will hold the configuration.
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Color and Appearance
config.color_scheme = "Dracula"
config.window_background_opacity = is_unix and 0.9 or 0.7

-- Font
config.font = wezterm.font("Hack Nerd Font Mono")
config.font_size = 14.0

if not is_unix then
  -- Emulate tmux key bingings
  config.leader = { key = "q", mods = "CTRL", timeout_milliseconds = 1000 }
  config.keys = {
    {
      key = "v",
      mods = "LEADER",
      action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "s",
      mods = "LEADER",
      action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "d",
      mods = "CTRL",
      action = wezterm.action.CloseCurrentPane({ confirm = true }),
    },
    {
      key = "h",
      mods = "CTRL",
      action = act.ActivatePaneDirection("Left"),
    },
    {
      key = "l",
      mods = "CTRL",
      action = act.ActivatePaneDirection("Right"),
    },
    {
      key = "k",
      mods = "CTRL",
      action = act.ActivatePaneDirection("Up"),
    },
    {
      key = "j",
      mods = "CTRL",
      action = act.ActivatePaneDirection("Down"),
    },
    {
      key = "c",
      mods = "LEADER",
      action = act.SpawnTab("CurrentPaneDomain"),
    },
    {
      key = "x",
      mods = "LEADER",
      action = act.PaneSelect({
        mode = "SwapWithActive",
      }),
    },
  }

  config.default_prog = { "nu.exe" }
else
  config.default_prog = { "/opt/homebrew/bin/nu" }
end

-- and finally, return the configuration to wezterm
return config
