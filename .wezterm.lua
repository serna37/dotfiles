local wezterm = require "wezterm"
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end
config.automatically_reload_config = true

-- 色
config.color_scheme = "Obsidian"
config.window_background_opacity = 0.85
config.colors = {
    foreground = "silver",
    background = "rgb(40, 40, 50)",
    cursor_fg = "rgb(0, 0, 0, 0.8)",
    cursor_bg = "rgb(160, 160, 160, 0.6)",
    selection_fg = "rgb(50, 170, 255, 0.9)",
    selection_bg = "rgb(171, 171, 171, 0.4)",
}

-- フォント
config.font = wezterm.font("Droid Sans Mono for Powerline", {weight="Medium", stretch="Normal", style="Normal"})
config.font_size = 12

-- ウィンドウ
config.initial_cols = 200
config.initial_rows = 60

-- バックスラッシュ
config.keys = {
    -- ¥ではなく、バックスラッシュを入力する。おそらくMac固有
    {
        key = "¥",
        action = wezterm.action.SendKey { key = "\\" }
    },
}

----------------------------------------------------
-- Tab
----------------------------------------------------
-- タイトルバーを非表示
config.window_decorations = "RESIZE"
-- タブバーの表示
config.show_tabs_in_tab_bar = true
-- タブが一つの時は非表示
--config.hide_tab_bar_if_only_one_tab = true
-- falseにするとタブバーの透過が効かなくなる
 --config.use_fancy_tab_bar = false

-- タブバーの透過
config.window_frame = {
  inactive_titlebar_bg = "none",
  active_titlebar_bg = "none",
}

-- タブバーを背景色に合わせる
config.window_background_gradient = {
  colors = { "rgb(40, 40, 50, 0.9)" },
}

-- タブの追加ボタンを非表示
--config.show_new_tab_button_in_tab_bar = false
-- nightlyのみ使用可能
-- タブの閉じるボタンを非表示
--config.show_close_tab_button_in_tabs = false

-- タブ同士の境界線を非表示
-- これを有効にするとvim中でカーソルのopacityが効かない
--config.colors = {
  --tab_bar = {
    --inactive_tab_edge = "none",
  --},
--}

-- タブの形をカスタマイズ
-- タブの左側の装飾
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
-- タブの右側の装飾
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

-- 各タブの「ディレクトリ名」を記憶しておくテーブル
local title_cache = {}

local function BaseName(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

wezterm.on("update-status", function(window, pane)
  local pane_id = pane:pane_id()
  local process_info = pane:get_foreground_process_info()
  if process_info then
    title_cache[pane_id] = BaseName(process_info.cwd)
  end
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local background = "#5c6d74"
  local foreground = "#FFFFFF"
  local HEADER = " "
  local edge_background = "none"
  if tab.is_active then
    background = "limegreen"
    foreground = "darkslategray"
    HEADER = ""
  end
  local edge_foreground = background
  -- 現在フォルダ
  local cwd = title_cache[tab.active_pane.pane_id] or "-"
  -- プロセス名
  local process = wezterm.truncate_right(tab.active_pane.title, max_width - 1)
  local title = HEADER .. process ..  " [" .. cwd .. "]"
  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = "  " .. title .. "  " },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)






return config


