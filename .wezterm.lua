local wezterm = require 'wezterm'
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- 色
config.color_scheme = 'Obsidian'
config.window_background_opacity = 0.85
config.colors = {
    foreground = 'silver',
    background = 'rgb(40, 40, 50)',
    cursor_fg = 'rgb(0, 0, 0, 0.8)',
    cursor_bg = 'rgb(160, 160, 160, 0.6)',
    selection_fg = 'rgb(50, 170, 255, 0.9)',
    selection_bg = 'rgb(171, 171, 171, 0.4)',
}

-- フォント
config.font = wezterm.font("Droid Sans Mono for Powerline", {weight="Medium", stretch="Normal", style="Normal"})
config.font_size = 12

-- ウィンドウ
config.initial_cols = 200
config.initial_rows = 55

-- バックスラッシュ
config.keys = {
    -- ¥ではなく、バックスラッシュを入力する。おそらくMac固有
    {
        key = "¥",
        action = wezterm.action.SendKey { key = '\\' }
    },
}

return config

