#!/bin/zsh

emulate -L zsh

render_todos() {
  printf '\033[1;38;5;210m  TODAY\033[0m\n'
  printf '\033[38;5;244m  3 remaining\033[0m\n'
  printf '\033[38;5;238m  ----------------------\033[0m\n\n'
  printf '  \033[38;5;210m[ ]\033[0m Review Rust notes\n\n'
  printf '  \033[38;5;210m[ ]\033[0m Finish blog outline\n\n'
  printf '  \033[38;5;210m[ ]\033[0m Stretch for 15 min\n\n'
  printf '  \033[2;9;38;5;244m[x] Read 30 pages\033[0m\n'
}

draw_todos() {
  local next_screen
  next_screen="$(render_todos)"

  if [[ "$next_screen" != "$last_screen" ]]; then
    printf '\033]0;wezterm-todo-sidebar\007'
    printf '\033[2J\033[H%s\n' "$next_screen"
    last_screen="$next_screen"
  fi
}

TRAPWINCH() {
  draw_todos
}

draw_todos

# Polling keeps external Todo changes nearly live without redrawing unchanged data.
while true; do
  if read -rs -k 1 -t 1 key && [[ "$key" == "q" ]]; then
    exit 0
  fi

  draw_todos
done
