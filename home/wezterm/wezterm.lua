-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Macchiato"
config.font = wezterm.font("RobotoMono Nerd Font")
config.font_size = 15
config.window_frame = {
  font = wezterm.font({ family = "Roboto", weight = "Bold" }),
  font_size = 15.0,
  active_titlebar_bg = "#333333",
  inactive_titlebar_bg = "#333333",
}
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.colors = {
  tab_bar = {
    active_tab = {
      bg_color = "#8aadf4",
      fg_color = "#24273a",
    },
  },
}
local act = wezterm.action
config.keys = {
  {
    key = "LeftArrow",
    mods = "SUPER",
    action = act.ActivateTabRelative(-1),
  },
  {
    key = "RightArrow",
    mods = "SUPER",
    action = act.ActivateTabRelative(1),
  },
  {
    key = "LeftArrow",
    mods = "SUPER|SHIFT",
    action = act.MoveTabRelative(-1),
  },
  {
    key = "RightArrow",
    mods = "SUPER|SHIFT",
    action = act.MoveTabRelative(1),
  },
  { key = "Backspace", mods = "CTRL", action = act.SendKey({ key = "w", mods = "CTRL" }) },
  { key = "Backspace", mods = "ALT",  action = act.SendKey({ key = "w", mods = "CTRL" }) },
}

-- and finally, return the configuration to wezterm
return config
