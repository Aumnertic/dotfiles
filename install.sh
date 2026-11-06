#!/usr/bin/env bash
# Symlink configs into $HOME. Existing files are backed up as *.bak.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"

link() {
  local src="$here/$1" dst="$HOME/$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && ! -L "$dst" ]]; then mv "$dst" "$dst.bak"; fi
  ln -sfn "$src" "$dst"
  echo "linked $dst"
}

link zsh/.zshrc .zshrc
link zsh/.zprofile .zprofile
link zsh/.zshenv .zshenv
link starship/starship.toml .config/starship.toml
link wezterm/.wezterm.lua .wezterm.lua
for f in fullscreen-background.lua tabs.lua render-wallpaper.swift todo-sidebar.zsh; do
  link "wezterm/.config/wezterm/$f" ".config/wezterm/$f"
done
