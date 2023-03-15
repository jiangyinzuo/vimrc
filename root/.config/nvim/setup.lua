require("nvim-treesitter.configs").setup {
	-- 安装 language parser
	-- :TSInstallInfo 命令查看支持的语言
	ensure_installed = { "cpp", "lua", "vim", "python" },
	-- 启用代码高亮模块
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
}

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>rg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.oldfiles, {})


require("mason").setup {
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
	github = {
		-- The template URL to use when downloading assets from GitHub.
		-- The placeholders are the following (in order):
		-- 1. The repository (e.g. "rust-lang/rust-analyzer")
		-- 2. The release version (e.g. "v0.3.0")
		-- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
		download_url_template = "https://cors.isteed.cc/github.com/%s/releases/download/%s/%s",
	},
}

require("lsp")

require('lsp-progress').setup({
    -- Spinning icons.
    spinner = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" },

    -- Spinning update time in milliseconds.
    spin_update_time = 200,

    -- Last message cached decay time in milliseconds.
    --
    -- Message could be really fast(appear and disappear in an
    -- instant) that user cannot even see it, thus we cache the last message
    -- for a while for user view.
    decay = 1000,

    -- User event name.
    event = "LspProgressStatusUpdated",

    -- Event update time limit in milliseconds.
    --
    -- Sometimes progress handler could emit many events in an instant, while
    -- refreshing statusline cause too heavy synchronized IO, so we limit the
    -- event rate to reduce this cost.
    event_update_time_limit = 125,

    --- Max progress string length, by default -1 is unlimit.
    max_size = -1,

    -- Format series message.
    --
    -- By default it looks like: `formatting isort (100%) - done`.
    --
    -- @param title      Message title.
    -- @param message    Message body.
    -- @param percentage Progress in percentage numbers: [0%-100%].
    -- @param done       Indicate if this message is the last one in progress.
    -- @return           A nil|string|table value. The returned value will be
    --                   passed to function `client_format` as one of the
    --                   `series_messages` array, or ignored if return nil.
    series_format = function(title, message, percentage, done)
        local builder = {}
        local has_title = false
        local has_message = false
        if title and title ~= "" then
            table.insert(builder, title)
            has_title = true
        end
        if message and message ~= "" then
            table.insert(builder, message)
            has_message = true
        end
        if percentage and (has_title or has_message) then
            table.insert(builder, string.format("(%.0f%%%%)", percentage))
        end
        if done and (has_title or has_message) then
            table.insert(builder, "- done")
        end
        return table.concat(builder, " ")
    end,

    -- Format client message.
    --
    -- By default it looks like:
    -- `[null-ls] ⣷ formatting isort (100%) - done, formatting black (50%)`.
    --
    -- @param client_name     Client name.
    -- @param spinner         Spinner icon.
    -- @param series_messages Series messages array.
    -- @return                A nil|string|table value. The returned value will
    --                        be passed to function `format` as one of the
    --                        `client_messages` array, or ignored if return nil.
    client_format = function(client_name, spinner, series_messages)
        return #series_messages > 0
                and ("[" .. client_name .. "] " .. spinner .. " " .. table.concat(
                    series_messages,
                    ", "
                ))
            or nil
    end,

    -- Format (final) message.
    --
    -- By default it looks like:
    -- ` LSP [null-ls] ⣷ formatting isort (100%) - done, formatting black (50%)`
    --
    -- @param client_messages Client messages array.
    -- @return                A nil|string|table value. The returned value will be
    --                        returned from `progress` API.
    format = function(client_messages)
        local sign = " LSP" -- nf-fa-gear \uf013
        return #client_messages > 0
                and (sign .. " " .. table.concat(client_messages, " "))
            or sign
    end,

    --- Enable debug.
    debug = false,

    --- Print log to console(command line).
    console_log = true,

    --- Print log to file.
    file_log = false,

    -- Log file to write, work with `file_log=true`.
    -- For Windows: `$env:USERPROFILE\AppData\Local\nvim-data\lsp-progress.log`.
    -- For *NIX: `~/.local/share/nvim/lsp-progress.log`.
    file_log_name = "lsp-progress.log",
})

require("tokyonight").setup({
	-- your configuration comes here
	-- or leave it empty to use the default settings
	style = "moon", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
	light_style = "night", -- The theme is used when the background is set to light
	transparent = false, -- Enable this to disable setting the background color
	terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
	styles = {
		-- Style to be applied to different syntax groups
		-- Value is any valid attr-list value for `:help nvim_set_hl`
		comments = { italic = false },
		keywords = { italic = false },
    functions = {},
    variables = {},
    -- Background styles. Can be "dark", "transparent" or "normal"
    sidebars = "dark", -- style for sidebars, see below
    floats = "dark", -- style for floating windows
  },
  sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
  day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
  hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
  dim_inactive = false, -- dims inactive windows
  lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

  --- You can override specific color groups to use other groups or a hex color
  --- function will be called with a ColorScheme table
  ---@param colors ColorScheme
  on_colors = function(colors) end,

  --- You can override specific highlights to use other groups or a hex color
  --- function will be called with a Highlights and ColorScheme table
  ---@param highlights Highlights
  ---@param colors ColorScheme
  on_highlights = function(highlights, colors) end,
})
vim.cmd[[colorscheme tokyonight]]

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics', 'filename'},
    lualine_c = {
			-- invoke `progress` to get lsp progress status.
      require("lsp-progress").progress,
		},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
