local wezterm = require("wezterm")

local act = wezterm.action
local rose_pine_moon = wezterm.color.get_builtin_schemes()["rose-pine-moon"]

rose_pine_moon.ansi[2] = "#c9828c"
rose_pine_moon.brights[2] = "#d9a0a8"

-- Use a cached frosted wallpaper only while the window is fullscreen.
dofile(wezterm.home_dir .. "/.config/wezterm/fullscreen-background.lua").setup(wezterm)

local tabs = dofile(wezterm.home_dir .. "/.config/wezterm/tabs.lua")
tabs.setup(wezterm)

return {
  initial_cols = 150,
  initial_rows = 44,
  -- Nerd Font symbols as fallback so starship / eza icons always render.
  font = wezterm.font_with_fallback({ "JetBrains Mono", "Symbols Nerd Font Mono" }),
  font_size = 14,
  color_schemes = {
    ["rose-pine-moon-soft-red"] = rose_pine_moon,
  },
  color_scheme = "OneDark (base16)",
  -- Frosted glass: the editor uses the terminal's default background.
  window_background_opacity = 0.88,
  macos_window_background_blur = 32,
  -- Use ToggleFullScreen to cover the current desktop without a separate Space.
  native_macos_fullscreen_mode = false,
  automatically_reload_config = true,
  text_background_opacity = 1.0,
  max_fps = 120,
  animation_fps = 60,
  default_cursor_style = "BlinkingBar",
  cursor_thickness = "2px",
  cursor_blink_rate = 600,
  cursor_blink_ease_in = "EaseInOut",
  cursor_blink_ease_out = "EaseInOut",
  colors = {
    cursor_bg = "#8AB8FF",
    cursor_border = "#8AB8FF",
    cursor_fg = "#282C34",
    tab_bar = tabs.colors,
  },
  window_padding = {
    left = 10,
    right = 10,
    top = 8,
    bottom = 8,
  },
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  tab_max_width = 36,
  show_tab_index_in_tab_bar = false,
  tab_bar_style = {
    new_tab = wezterm.format({ { Text = "  +  " } }),
    new_tab_hover = wezterm.format({ { Text = "  +  " } }),
  },
  -- Hide the native title bar while preserving resizing from the window edges.
  window_decorations = "RESIZE",

  keys = {
    {
      key = "Enter",
      mods = "ALT",
      action = act.ToggleFullScreen,
    },
    {
      key = "f",
      mods = "CMD|CTRL",
      action = act.ToggleFullScreen,
    },
    {
      key = "d",
      mods = "CMD",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "d",
      mods = "CMD|SHIFT",
      action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "w",
      mods = "CMD",
      action = act.CloseCurrentPane({ confirm = true }),
    },
    {
      key = "LeftArrow",
      mods = "CMD",
      action = act.SendKey({ key = "Home" }),
    },
    {
      key = "RightArrow",
      mods = "CMD",
      action = act.SendKey({ key = "End" }),
    },
    {
      key = "LeftArrow",
      mods = "CMD|SHIFT",
      action = act.ActivatePaneDirection("Left"),
    },
    {
      key = "RightArrow",
      mods = "CMD|SHIFT",
      action = act.ActivatePaneDirection("Right"),
    },
    {
      key = "UpArrow",
      mods = "CMD|SHIFT",
      action = act.ActivatePaneDirection("Up"),
    },
    {
      key = "DownArrow",
      mods = "CMD|SHIFT",
      action = act.ActivatePaneDirection("Down"),
    },
    {
      key = "j",
      mods = "CMD|SHIFT",
      action = act.ActivateTabRelative(-1),
    },
    {
      key = "k",
      mods = "CMD|SHIFT",
      action = act.ActivateTabRelative(1),
    },
  },
}
