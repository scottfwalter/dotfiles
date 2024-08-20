-- Pull in the wezterm API
local wezterm = require("wezterm")

-- Pull in custom appearance module
local appearance = require("appearance")

-- This will hold the configuration.
local config = wezterm.config_builder()

--function scheme_for_appearance(appearance)
--  if appearance:find "Dark" then
--  else
--    return "Catppuccin Latte"
--  end
--end
--
--config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),

if appearance.is_dark() then
	config.color_scheme = "AdventureTime"
	config.color_scheme = "Palenight (Gogh)"
	config.color_scheme = "Catppuccin Mocha"
	config.color_scheme = "Tokyo Night"
else
	config.color_scheme = "Catppuccin Latte"
	config.color_scheme = "Tokyo Night Day"
end

config.color_scheme = "AdventureTime"
config.color_scheme = "Palenight (Gogh)"
config.color_scheme = "Tokyo Night"
config.color_scheme = "Catppuccin Latte"
config.color_scheme = "Catppuccin Mocha"
config.color_scheme = "Dracula (Official)"

--config.font = wezterm.font("3270 Nerd Font Mono")
config.font = wezterm.font("0xProto Nerd Font Mono")
config.font_size = 14.0

config.window_background_opacity = 0.8
--config.macos_window_background_blur = 10

-- config.background = {
-- {
-- 	source = {
-- 		File = wezterm.config_dir .. "/backgrounds/yoda.jpg",
-- },
-- opacity = 0.3, -- Adjust the image opacity
-- },
-- }

config.window_decorations = "RESIZE|INTEGRATED_BUTTONS"

local function segments_for_right_status(window)
	return {
		window:active_workspace(),
		wezterm.strftime("%a %b %-d %H:%M"),
		wezterm.hostname(),
	}
end

wezterm.on("update-status", function(window, _)
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
			orientation = "Horizontal",
			colors = { gradient_from, gradient_to },
		},
		#segments -- only gives us as many colours as we have segments.
	)

	-- We'll build up the elements to send to wezterm.format in this table.
	local elements = {}

	for i, seg in ipairs(segments) do
		local is_first = i == 1

		if is_first then
			table.insert(elements, { Background = { Color = "none" } })
		end
		table.insert(elements, { Foreground = { Color = gradient[i] } })
		table.insert(elements, { Text = SOLID_LEFT_ARROW })

		table.insert(elements, { Foreground = { Color = fg } })
		table.insert(elements, { Background = { Color = gradient[i] } })
		table.insert(elements, { Text = " " .. seg .. " " })
	end

	window:set_right_status(wezterm.format(elements))
end)

config.launch_menu = {
	{
		args = { "/opt/homebrew/bin/btop" },
		label = "BTop",
	},
	{
		-- Optional label to show in the launcher. If omitted, a label
		-- is derived from the `args`
		label = "ZShell",
		-- The argument array to spawn.  If omitted the default program
		-- will be used as described in the documentation above
		args = { "zsh", "-l" },

		-- You can specify an alternative current working directory;
		-- if you don't specify one then a default based on the OSC 7
		-- escape sequence will be used (see the Shell Integration
		-- docs), falling back to the home directory.
		-- cwd = "/some/path"

		-- You can override environment variables just for this command
		-- by setting this here.  It has the same semantics as the main
		-- set_environment_variables configuration option described above
		-- set_environment_variables = { FOO = "bar" },
	},
}

config.skip_close_confirmation_for_processes_named = {
	"btop",
}

-- and finally, return the configuration to wezterm
return config
