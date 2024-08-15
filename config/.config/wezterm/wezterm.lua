-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- Pull in custom appearance module
local appearance = require 'appearance'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- For example, changing the color scheme:
--config.color_scheme = 'AdventureTime'
--config.color_scheme = 'Palenight (Gogh)'
--config.color_scheme = 'Tokyo Night'


--function scheme_for_appearance(appearance)
--  if appearance:find "Dark" then
--    return "Catppuccin Mocha"
--  else
--    return "Catppuccin Latte"
--  end
--end
--
--config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),

if appearance.is_dark() then
  config.color_scheme = 'Tokyo Night'
else
  config.color_scheme = 'Tokyo Night Day'
end

config.color_scheme = 'AdventureTime'
config.color_scheme = 'Palenight (Gogh)'
config.color_scheme = 'Tokyo Night'
config.color_scheme = 'Catppuccin Latte'
config.color_scheme = 'Catppuccin Mocha'
config.color_scheme = 'Dracula (Official)'

config.font = wezterm.font '3270 Nerd Font Mono'
config.font = wezterm.font '0xProto Nerd Font Mono'
config.font_size = 14.0

config.window_background_opacity = 0.9
--config.macos_window_background_blur = 10

-- Removes the title bar, leaving only the tab bar. Keeps
-- the ability to resize by dragging the window's edges.
-- On macOS, 'RESIZE|INTEGRATED_BUTTONS' also looks nice if
-- you want to keep the window controls visible and integrate
-- them into the tab bar.
config.window_decorations = 'RESIZE'

wezterm.on('update-status', function(window)
  -- Grab the utf8 character for the "powerline" left facing
  -- solid arrow.
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

  -- Grab the current window's configuration, and from it the
  -- palette (this is the combination of your chosen colour scheme
  -- including any overrides).
  local color_scheme = window:effective_config().resolved_palette
  local bg = color_scheme.background
  local fg = color_scheme.foreground

  window:set_right_status(wezterm.format({
    -- First, we draw the arrow...
    { Background = { Color = 'none' } },
    { Foreground = { Color = bg } },
    { Text = SOLID_LEFT_ARROW },
    -- Then we draw our text
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = ' ' .. wezterm.hostname() .. ' ' },
  }))
end)


-- and finally, return the configuration to wezterm
return config
