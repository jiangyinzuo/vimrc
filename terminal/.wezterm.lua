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

-- config.color_scheme = 'Solarized Light (Gogh)'
-- config.color_scheme = 'Solarized (light) (terminal.sexy)'
-- config.color_scheme = 'Solarized Dark (Gogh)'
config.color_scheme = 'Solarized (dark) (terminal.sexy)'

config.font_size = 14.0
config.initial_rows = 27
config.initial_cols = 90

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
end

config.font = wezterm.font_with_fallback {
  -- <built-in>, BuiltIn
  "JetBrains Mono",

  -- <built-in>, BuiltIn
  -- Assumed to have Emoji Presentation
  -- Pixel sizes: [128]
  "Noto Color Emoji",

  -- <built-in>, BuiltIn
  "Symbols Nerd Font Mono",

  "Microsoft YaHei",
  -- https://fonts.google.com/noto/specimen/Noto+Sans+SC?noto.query=SC
  -- "Noto Sans SC",

  -- https://fonts.google.com/noto/use#faq
  -- https://github.com/notofonts/noto-cjk/tree/main/Sans/Mono
  "Noto Sans Mono CJK SC",
  -- https://fonts.google.com/noto/specimen/Noto+Sans+Math
  "Noto Sans Math",
}

-- and finally, return the configuration to wezterm
return config
