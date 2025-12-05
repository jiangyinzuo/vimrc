-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

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
config.color_scheme = "Solarized (dark) (terminal.sexy)"

config.font_size = 14.0
config.initial_rows = 27
config.initial_cols = 90
config.enable_kitty_graphics = true

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.default_prog = { "wsl.exe", "--cd", "~" }
	config.launch_menu = {
		{
			label = "New Tab: cmd.exe",
			args = { "cmd.exe" },
		},
		{
			label = "New Tab: powershell.exe",
			args = { "powershell.exe", "-NoLogo" },
		},
	}
end

config.font = wezterm.font_with_fallback({
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
})

wezterm.on("augment-command-palette", function(window, pane)
	return {
		{
			brief = "Rename tab",
			icon = "md_rename_box",

			action = act.PromptInputLine({
				description = "Enter new name for tab",
				initial_value = "My Tab Name",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
		{
			brief = "cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .. 【cmake生成compile_commands.json】",
			icon = "cod_terminal_bash",
			action = wezterm.action.SendString("cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .."),
		},
		{
			brief = "split -l 100 -d sift1b_10m.csv sift1b_10m.csv.part 【split分割文件，每个文件100行，数字命名后缀】",
			icon = "cod_terminal_bash",
			action = wezterm.action.SendString("split -l 100 -d sift1b_10m.csv sift1b_10m.csv.part"),
		},
		{
			brief = "git diff --shortstat 【git统计代码行数，汇总统计】",
			icon = "cod_terminal_bash",
			action = wezterm.action.SendString("git diff --shortstat"),
		},
		{
			brief = "git diff --numstat --shortstat 【git统计代码行数，细分每个文件+汇总统计】",
			icon = "cod_terminal_bash",
			action = wezterm.action.SendString("git diff --numstat --shortstat"),
		},
		{
			brief = "git add -u 【git只add git正在跟踪的文件】",
			icon = "cod_terminal_bash",
			action = wezterm.action.SendString("git add -u"),
		},
	}
end)

-- and finally, return the configuration to wezterm
return config
