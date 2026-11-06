#!/usr/bin/env bash
# One-shot setup for macOS:
#   curl -fsSL https://raw.githubusercontent.com/Aumnertic/dotfiles/main/install.sh | bash
#
# Installs Homebrew (if missing), CLI tools, WezTerm, Nerd Fonts and zsh plugins,
# then symlinks the configs into $HOME. Existing files are backed up as *.bak.
# Safe to run again.
set -euo pipefail

REPO="https://github.com/Aumnertic/dotfiles.git"
DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

say()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m  %s\n' "$*"; }

[[ "$(uname)" == "Darwin" ]] || { warn "只支持 macOS。"; exit 1; }

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1; then
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [[ -x "$b" ]] && eval "$("$b" shellenv)"
  done
fi
if ! command -v brew >/dev/null 2>&1; then
  say "安装 Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  for b in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [[ -x "$b" ]] && eval "$("$b" shellenv)"
  done
fi

# 2. Get the repo (when run via curl there is no local checkout)
here="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [[ -n "$here" && -f "$here/zsh/.zshrc" ]]; then
  DOTFILES="$here"
elif [[ -d "$DOTFILES/.git" ]]; then
  say "更新 $DOTFILES"
  git -C "$DOTFILES" pull --ff-only
else
  say "克隆到 $DOTFILES"
  git clone --depth 1 "$REPO" "$DOTFILES"
fi

# 3. Packages
say "安装命令行工具"
brew install starship eza bat zoxide ast-grep neovim

say "安装 WezTerm 和字体"
# JetBrains Mono for text, Nerd Font variants for the icons in the prompt and eza.
for cask in wezterm font-jetbrains-mono font-jetbrains-mono-nerd-font font-symbols-only-nerd-font; do
  if brew list --cask "$cask" >/dev/null 2>&1; then
    echo "$cask 已安装"
  elif [[ "$cask" == wezterm && -d /Applications/WezTerm.app ]]; then
    echo "WezTerm.app 已存在"
  else
    brew install --cask "$cask"
  fi
done

# 4. zsh plugins
plugins="$HOME/.zsh/plugins"
mkdir -p "$plugins"
for p in zsh-autosuggestions zsh-syntax-highlighting; do
  if [[ -d "$plugins/$p/.git" ]]; then
    git -C "$plugins/$p" pull --ff-only -q
  else
    say "安装 $p"
    git clone --depth 1 "https://github.com/zsh-users/$p" "$plugins/$p"
  fi
done

# 5. Symlinks
link() {
  local src="$DOTFILES/$1" dst="$HOME/$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    return
  fi
  if [[ -e "$dst" || -L "$dst" ]]; then
    mv "$dst" "$dst.bak"
    echo "备份 $dst -> $dst.bak"
  fi
  ln -s "$src" "$dst"
  echo "链接 $dst"
}

say "链接配置文件"
link zsh/.zshrc .zshrc
link zsh/.zprofile .zprofile
link zsh/.zshenv .zshenv
link starship/starship.toml .config/starship.toml
link wezterm/.wezterm.lua .wezterm.lua
for f in fullscreen-background.lua tabs.lua render-wallpaper.swift todo-sidebar.zsh; do
  link "wezterm/.config/wezterm/$f" ".config/wezterm/$f"
done

# 6. Default shell
if [[ "${SHELL:-}" != */zsh ]]; then
  warn "默认 shell 不是 zsh，可运行: chsh -s /bin/zsh"
fi

say "完成。打开 WezTerm 即可，图标会正常显示。"
cat <<'EOF'

如果用的是 Terminal.app / iTerm2 / VS Code 终端，需要把字体改成
"JetBrainsMono Nerd Font"，否则提示符和 ls 的图标会显示成方块。
API key 之类放到 ~/.zshrc.secrets（不进仓库）。
EOF
