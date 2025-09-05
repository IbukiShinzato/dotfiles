local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- カラースキーム
config.color_scheme = "catppuccin-mocha"

-- フォント
config.font = wezterm.font_with_fallback({
    "JetBrainsMono Nerd Font",
    "Cica",
})
config.font_size = 15

-- Tabline
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
    options = {
        theme = "cyberpunk",
        section_separators = {
            left = wezterm.nerdfonts.ple_upper_left_triangle,
            right = wezterm.nerdfonts.ple_lower_right_triangle,
        },
        component_separators = {
            left = wezterm.nerdfonts.ple_forwardslash_separator,
            right = wezterm.nerdfonts.ple_forwardslash_separator,
        },
        tab_separators = {
            left = wezterm.nerdfonts.ple_upper_left_triangle,
            right = wezterm.nerdfonts.ple_lower_right_triangle,
        },
        theme_overrides = {
            tab = {
                active = { fg = "#091833", bg = "#59c2c6" },
            },
        },
    },
    sections = {
        tab_active = {
            "index",
            { "process", padding = { left = 1, right = 3 } },
            "",
            { "cwd", padding = { left = 2, right = 2 } },
            { "zoomed", padding = 1 },
        },
        tab_inactive = {
            "index",
            { "process", padding = { left = 2, right = 1 } },
            "󰉋",
            { "cwd", padding = { left = 10, right = 2 } },
            { "zoomed", padding = 1 },
        },
    },
})

-- カーソル
config.default_cursor_style = "SteadyBlock"
config.colors = {
    cursor_fg = "#11111b",
    cursor_bg = "#59c2c6",
    cursor_border = "#59c2c6",
}

-- 背景透過
config.window_background_opacity = 0.8
config.macos_window_background_blur = 10

-- Window サイズ
config.initial_rows = 40
config.initial_cols = 140

return config

