-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'AdventureTime'
config.color_scheme = 'Palenight (Gogh)'
--config.color_scheme = 'Batman'

--config.font = wezterm.font 'IBM 3270 Nerd Font Complete Mono'
--config.font = wezterm.font 'OxProto Nerd Font'
config.font = wezterm.font '0xProto Nerd Font'
config.font_size = 14.0

config.window_background_opacity = 0.9

--config.default_prog = { '/usr/local/bin/fish', '-l' }
--config.default_prog = { '/opt/homebrew/bin/tmux attach || /opt/homebrew/bin/tmux' }

-- and finally, return the configuration to wezterm
return config
