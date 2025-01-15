-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- overwrite key bindings
-- This will create a new split and run your default program inside it
config.keys = {
  -- close window
  {
    key = 'd',
    mods = 'CMD|SHIFT',
    action = wezterm.action.CloseCurrentPane { confirm = true },
  },
  -- horizontal split
  {
    key = 'o',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  -- vertical split
  {
    key = 'e',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },

}

-- set theme
config.color_scheme = "Banana Blueberry"

-- and finally, return the configuration to wezterm
return config