local M = {}

M.colors = {
  background = "#1B2230",
  active_tab = { bg_color = "#304968", fg_color = "#BDD7FF", intensity = "Bold" },
  inactive_tab = { bg_color = "#252D3B", fg_color = "#8E9BAF" },
  inactive_tab_hover = { bg_color = "#2D3B50", fg_color = "#D2DEEF" },
  new_tab = { bg_color = "#1B2230", fg_color = "#8E9BAF" },
  new_tab_hover = { bg_color = "#2D3B50", fg_color = "#BDD7FF" },
}

local function basename(path)
  path = (path or ""):gsub("[/\\]+$", "")
  return path:match("([^/\\]+)$") or ""
end

local function directory(pane, home)
  local cwd = pane.current_working_dir
  if not cwd then return "~" end
  local path
  if type(cwd) == "string" then
    path = cwd:gsub("^%a[%w+.-]*://[^/]*", "")
    path = path:gsub("%%(%x%x)", function(hex) return string.char(tonumber(hex, 16)) end)
  else
    path = cwd.file_path
  end
  if not path or path == home or path == home .. "/" then return "~" end
  if path == "/" then return "/" end
  return basename(path)
end

function M.setup(wezterm)
  wezterm.on("format-tab-title", function(tab, _, _, _, hover, max_width)
    local palette = M.colors.inactive_tab
    if tab.is_active then
      palette = M.colors.active_tab
    elseif hover then
      palette = M.colors.inactive_tab_hover
    end

    local pane = tab.active_pane or {}
    local program = basename(pane.foreground_process_name)
    if program == "" then program = "shell" end
    local name = tab.tab_title
    if not name or name == "" then
      name = directory(pane, wezterm.home_dir) .. " · " .. program
    end
    local title = tostring(tab.tab_index + 1) .. " · " .. name
    title = title:gsub("%c", " ")
    title = wezterm.truncate_right(title, math.max(0, max_width - 4))

    return {
      { Background = { Color = M.colors.background } },
      { Foreground = { Color = palette.bg_color } },
      { Text = "" },
      { Background = { Color = palette.bg_color } },
      { Foreground = { Color = palette.fg_color } },
      { Attribute = { Intensity = tab.is_active and "Bold" or "Normal" } },
      { Text = " " .. title .. " " },
      { Attribute = { Intensity = "Normal" } },
      { Background = { Color = M.colors.background } },
      { Foreground = { Color = palette.bg_color } },
      { Text = "" },
    }
  end)
end

return M
