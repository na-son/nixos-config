-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- overwrite key bindings
-- This will create a new split and run your default program inside it
config.keys = { -- close window
{
    key = 'd',
    mods = 'CMD|SHIFT',
    action = wezterm.action.CloseCurrentPane {
        confirm = true
    }
}, -- horizontal split
{
    key = 'o',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitHorizontal {
        domain = 'CurrentPaneDomain'
    }
}, -- vertical split
{
    key = 'e',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical {
        domain = 'CurrentPaneDomain'
    }
}, q}

config.window_decorations = "INTEGRATED_BUTTONS|TITLE"

-- set theme
config.color_scheme = "Banana Blueberry"

function fullscreen_toggle(window, pane)
  local overrides = window:get_config_overrides() or {}
  local is_fullscreen = window:get_dimensions().is_full_screen

  if is_fullscreen then
    overrides.enable_tab_bar = false
    overrides.window_decorations = 'NONE'
    wezterm.log_info("Setting to fullscreen mode")
  else
    overrides.enable_tab_bar = true
    overrides.window_decorations = 'INTEGRATED_BUTTONS|TITLE'
  end
  window:set_config_overrides(overrides)
end

wezterm.on('window-resized', fullscreen_toggle)

-- and finally, return the configuration to wezterm
return config
