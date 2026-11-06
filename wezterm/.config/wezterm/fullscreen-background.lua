local M = {}

local function same_value(a, b)
  if type(a) ~= type(b) then return false end
  if type(a) ~= "table" then return a == b end
  for key, value in pairs(a) do
    if not same_value(value, b[key]) then return false end
  end
  for key in pairs(b) do
    if a[key] == nil then return false end
  end
  return true
end

function M.setup(wezterm)
  local wallpaper = wezterm.home_dir .. "/.config/wezterm/assets/desktop-wallpaper-blurred.png"
  local fullscreen_background = {
    {
      source = { File = wallpaper },
      width = "Cover",
      height = "Cover",
      horizontal_align = "Center",
      vertical_align = "Middle",
      repeat_x = "NoRepeat",
      repeat_y = "NoRepeat",
      opacity = 1.0,
    },
    {
      -- Match the existing OneDark canvas at 88% opacity over the wallpaper.
      source = { Color = "#282C34" },
      width = "100%",
      height = "100%",
      opacity = 0.88,
    },
  }

  local function update_background(window)
    local overrides = window:get_config_overrides() or {}
    if window:get_dimensions().is_full_screen then
      if same_value(overrides.background, fullscreen_background) then return end
      overrides.background = fullscreen_background
    else
      -- Restore the base config: native desktop blur, with no internal image.
      if overrides.background == nil then return end
      overrides.background = nil
    end
    -- Preserve unrelated overrides and avoid recursive config reloads.
    window:set_config_overrides(overrides)
  end

  wezterm.on("window-resized", update_background)
  wezterm.on("window-config-reloaded", update_background)
end

return M
