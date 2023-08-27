-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'Solarized Dark (Gogh)'
config.font_size = 14.0
config.initial_rows = 24
config.initial_cols = 80

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_prog = { 'wsl.exe', '--cd', '~' }
  config.launch_menu = {
    {
      label = "New Tab: cmd.exe",
      args = { "cmd.exe" }
    },
    {
      label = "New Tab: powershell.exe",
      args = { "powershell.exe", "-NoLogo" }
    }
  }
elseif wezterm.target_triple == 'x86_64-unknown-linux-gnu' then
  config.font = wezterm.font_with_fallback({
    -- <built-in>, BuiltIn
    "JetBrains Mono",

    -- /usr/share/fonts/truetype/noto/NotoColorEmoji.ttf, FontConfig
    -- Assumed to have Emoji Presentation
    -- Pixel sizes: [128]
    "Noto Color Emoji",

    -- <built-in>, BuiltIn
    "Symbols Nerd Font Mono",
    "Noto Sans Mono CJK TC",
  })
end

-- and finally, return the configuration to wezterm
return config
