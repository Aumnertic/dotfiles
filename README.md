# dotfiles

macOS 上的 zsh / Starship / WezTerm 配置。

```
zsh/        .zshrc .zprofile .zshenv
starship/   starship.toml
wezterm/    .wezterm.lua + .config/wezterm/（标签栏、全屏毛玻璃背景）
```

## 安装

```sh
git clone https://github.com/Aumnertic/dotfiles ~/dotfiles
~/dotfiles/install.sh   # 软链到 $HOME，已有文件会备份成 .bak
```

依赖（Homebrew）：`starship eza bat zoxide ast-grep`，字体 JetBrains Mono + 任意 Nerd Font（提示符图标）。
zsh 插件手动克隆到 `~/.zsh/plugins/`：

```sh
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/plugins/zsh-syntax-highlighting
```

## 说明

- **密钥不在仓库里**。`.zshrc` 会读取 `~/.zshrc.secrets`，参考 `zsh/.zshrc.secrets.example`。
- **Starship**：本机由 Kaku 的 shell 集成初始化 starship；不用 Kaku 时 `.zshrc` 退回 `vcs_info` 简易提示符。想直接用 starship，在 `.zshrc` 末尾加 `eval "$(starship init zsh)"`。
- **WezTerm 全屏背景**：壁纸图片没有放进仓库。把自己的壁纸放到 `~/.config/wezterm/assets/desktop-wallpaper.png`，运行 `swift ~/.config/wezterm/render-wallpaper.swift` 生成模糊版本。详见 `wezterm/.config/wezterm/README.md`。
