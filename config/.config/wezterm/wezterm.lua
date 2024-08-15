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

local function segments_for_right_status(window)
  return {
    window:active_workspace(),
    wezterm.strftime('%a %b %-d %H:%M'),
    wezterm.hostname(),
  }
end

wezterm.on('update-status', function(window, _)
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
  local segments = segments_for_right_status(window)

  local color_scheme = window:effective_config().resolved_palette
  -- Note the use of wezterm.color.parse here, this returns
  -- a Color object, which comes with functionality for lightening
  -- or darkening the colour (amongst other things).
  local bg = wezterm.color.parse(color_scheme.background)
  local fg = color_scheme.foreground

  -- Each powerline segment is going to be coloured progressively
  -- darker/lighter depending on whether we're on a dark/light colour
  -- scheme. Let's establish the "from" and "to" bounds of our gradient.
  local gradient_to, gradient_from = bg
  if appearance.is_dark() then
    gradient_from = gradient_to:lighten(0.2)
  else
    gradient_from = gradient_to:darken(0.2)
  end

  -- Yes, WezTerm supports creating gradients, because why not?! Although
  -- they'd usually be used for setting high fidelity gradients on your terminal's
  -- background, we'll use them here to give us a sample of the powerline segment
  -- colours we need.
  local gradient = wezterm.color.gradient(
    {
      orientation = 'Horizontal',
      colors = { gradient_from, gradient_to },
    },
    #segments -- only gives us as many colours as we have segments.
  )

  -- We'll build up the elements to send to wezterm.format in this table.
  local elements = {}

  for i, seg in ipairs(segments) do
    local is_first = i == 1

    if is_first then
      table.insert(elements, { Background = { Color = 'none' } })
    end
    table.insert(elements, { Foreground = { Color = gradient[i] } })
    table.insert(elements, { Text = SOLID_LEFT_ARROW })

    table.insert(elements, { Foreground = { Color = fg } })
    table.insert(elements, { Background = { Color = gradient[i] } })
    table.insert(elements, { Text = ' ' .. seg .. ' ' })
  end

  window:set_right_status(wezterm.format(elements))
end)

--wezterm.on('update-status', function(window)
--  -- Grab the utf8 character for the "powerline" left facing
--  -- solid arrow.
--  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)
--
--  -- Grab the current window's configuration, and from it the
--  -- palette (this is the combination of your chosen colour scheme
--  -- including any overrides).
--  local color_scheme = window:effective_config().resolved_palette
--  local bg = color_scheme.background
--  local fg = color_scheme.foreground
--
--  window:set_right_status(wezterm.format({
--    -- First, we draw the arrow...
--    { Background = { Color = 'none' } },
--    { Foreground = { Color = bg } },
--    { Text = SOLID_LEFT_ARROW },
--    -- Then we draw our text
--    { Background = { Color = bg } },
--    { Foreground = { Color = fg } },
--    { Text = ' ' .. wezterm.hostname() .. ' ' },
--  }))
--end)


-- and finally, return the configuration to wezterm
return config
