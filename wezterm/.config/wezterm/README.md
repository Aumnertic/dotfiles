# WezTerm 背景

主配置：`~/.wezterm.lua`。全屏背景逻辑：`fullscreen-background.lua`。

- 窗口模式：沿用 88% 背景不透明度、32 的 macOS 背景模糊，不加载内部壁纸。
- 全屏模式：自动显示桌面壁纸的模糊缓存，叠加 88% 的 OneDark 深色底色。
- 退出全屏：移除壁纸覆盖，恢复窗口模式；普通最大化仍算窗口模式。

检测使用 `window:get_dimensions().is_full_screen`，在窗口尺寸变化和配置重载时同步。`set_config_overrides` 仅在背景发生变化时调用，保留其他窗口覆盖设置。

壁纸来源是系统桌面配置记录的 `~/Documents/33.png`（蜡笔小新、蓝天草地），原图副本保存在 `assets/desktop-wallpaper.png`。macOS 的窗口模糊不会模糊终端自己绘制的图片，因此全屏使用预先以高斯滤镜制作的 `assets/desktop-wallpaper-blurred.png`，原始壁纸保持原样。

更新壁纸时替换 `assets/desktop-wallpaper.png`，然后运行：

```sh
swift ~/.config/wezterm/render-wallpaper.swift
```

按 `Cmd+R` 重载配置。`Option+Enter` 切换全屏。

## 标签栏

标签栏放在底部，用圆角字符绘制胶囊。当前标签为蓝灰色底、浅蓝色粗体文字，其他标签为较暗的底色，悬停时适当提亮。

标题显示“序号 · 当前目录 · 程序”，例如 `1 · 项目名 · nvim`；过长标题会按可用宽度截断。手动设置的标签标题优先保留。只有一个标签时仍自动隐藏，按 `Cmd+T` 新建标签即可看到样式。

样式和标题逻辑位于 `tabs.lua`，标签栏的位置、最大宽度在 `~/.wezterm.lua` 中配置。
