# dotfiles

macOS 上的 zsh / Starship / WezTerm 配置。

```
zsh/        .zshrc .zprofile .zshenv
starship/   starship.toml
wezterm/    .wezterm.lua + .config/wezterm/（标签栏、全屏毛玻璃背景）
```

## 安装

一行命令（macOS）：

```sh
curl -fsSL https://raw.githubusercontent.com/Aumnertic/dotfiles/main/install.sh | bash
```

脚本会：装 Homebrew（没有的话）→ 装 `starship eza bat zoxide ast-grep neovim` → 装 WezTerm、JetBrains Mono 和 Nerd Font → 克隆两个 zsh 插件 → 把配置软链到 `$HOME`（已有文件备份成 `.bak`）。可以重复运行。

### 图标显示成方块？

提示符和 `ls`（eza）的图标来自 Nerd Font。WezTerm 已配置自动回退到 Nerd Font 符号，开箱即用；其他终端（Terminal.app、iTerm2、VS Code）要手动把字体设成 **JetBrainsMono Nerd Font**。

## 说明

- **密钥不在仓库里**。`.zshrc` 会读取 `~/.zshrc.secrets`，参考 `zsh/.zshrc.secrets.example`。
- **Starship**：`.zshrc` 末尾自动 `starship init`（在 Kaku 里由 Kaku 自己初始化，不会重复）；没装 starship 时退回 `vcs_info` 简易提示符。
- **WezTerm 全屏背景**：壁纸图片没有放进仓库，没有壁纸时全屏就是普通毛玻璃。把自己的壁纸放到 `~/.config/wezterm/assets/desktop-wallpaper.png`，运行 `swift ~/.config/wezterm/render-wallpaper.swift` 生成模糊版本。详见 `wezterm/.config/wezterm/README.md`。
